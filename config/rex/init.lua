-- Rex configuration (https://www.superlogical.com/rex/docs/customize/config)
-- Apply changes with: rex config reload

-- Sidebar
rex.unbind("cmd+/", "client.sidebar.toggle")
rex.bind("cmd+s", "client.sidebar.toggle")

-- Quick switcher (experimental)
rex.bind("shift+cmd+\\", "client.setting.developer.experimental.new_quick_switcher")

-- ----------------------------------------
-- Copy a command's output
-- ----------------------------------------
--
-- The same walk as C-S-k / C-S-j in tmux.conf: copy the last command's output
-- and select it in copy mode, then step to older or newer outputs.
--
-- Rex's capture drops OSC 133 marks, so prompts are found by their text:
--   * the local zsh prompt, whose last line starts with PROMPT_GLYPH and has a
--     path line (and usually a blank line) above it (see zsh/prompt.zsh)
--   * a one-line "user@host:path$ " prompt, the bash default on remote hosts
-- Change these if a prompt changes.

local TERMINAL = "com.superlogical.terminal"
local PROMPT_GLYPH = "\243\177\144\139" -- U+F140B
local REMOTE_PROMPT = "^[%w_.%-]+@[%w_.%-]+:[^\n]-[%$#][ \n]"
local VENV_PREFIX = "^%([^\n)]+%) " -- "(venv) " in front of a remote prompt
local MAX_REPLY = 983040 -- the most one reply can carry
local TAIL_BYTES = 4 * 1024 * 1024 -- how far back to read in a long scrollback

-- The pane's scrollback as plain text, or its last TAIL_BYTES when it is too
-- long for one reply. Without unwrap, each line is one row of the terminal.
local function scrollback(ctx, unwrap)
    local r, err = rex.block.call(TERMINAL, "format", {
        block_id = ctx.block_id,
        format = "text",
        unwrap = unwrap,
        trim = true,
        max_bytes = MAX_REPLY,
    })
    if r == nil then error(err, 0) end
    if r.id == nil then return r.content end

    local parts = {}
    local offset = math.max(0, (r.total or 0) - TAIL_BYTES)
    repeat
        local b, berr = rex.block.call(TERMINAL, "blob_read", {
            block_id = ctx.block_id,
            id = r.id,
            offset = offset,
            max_bytes = MAX_REPLY,
        })
        if b == nil then error(berr, 0) end
        parts[#parts + 1] = b.data
        offset = offset + #b.data
    until b.eof or #b.data == 0
    return table.concat(parts)
end

local NEWLINE = 10
local BLANK = { [9] = true, [10] = true, [13] = true, [32] = true }

-- Whether the line at pos is a prompt, and how many lines of that prompt sit
-- above it.
local function prompt_at(text, pos)
    if text:sub(pos, pos + #PROMPT_GLYPH - 1) == PROMPT_GLYPH then
        return true, 1 -- the path line
    end
    local _, venv_end = text:find(VENV_PREFIX, pos)
    if text:find(REMOTE_PROMPT, (venv_end or pos - 1) + 1) then
        return true, 0
    end
    return false
end

-- Every prompt's last line as { pos, nl, row, above }, oldest first, and the
-- number of lines in text. Works on byte offsets because a table of every
-- line overflows Lua's stack on a long scrollback.
local function prompts(text)
    if text:sub(-1) ~= "\n" then
        text = text .. "\n" -- so an empty prompt on the last line still ends in one
    end
    local list, row = {}, 0
    local pos, len = 1, #text
    while pos <= len do
        row = row + 1
        local nl = text:find("\n", pos, true) or (len + 1)
        local found, above = prompt_at(text, pos)
        if found then
            list[#list + 1] = { pos = pos, nl = nl, row = row, above = above }
        end
        pos = nl + 1
    end
    return list, row
end

-- The nth newest command output, skipping commands that printed nothing. An
-- output is the text between two prompts, without the command line above it
-- or the upper lines (and blank line) of the prompt below it.
local function nth_output(text, n)
    local list, rows = prompts(text)
    local found = 0
    for i = #list, 2, -1 do
        local first, last = list[i - 1].nl + 1, list[i].pos - 2
        for _ = 1, list[i].above do
            while last >= first and text:byte(last) ~= NEWLINE do
                last = last - 1 -- drop a line of the prompt below
            end
            last = last - 1
        end
        while last >= first and BLANK[text:byte(last)] do
            last = last - 1 -- drop trailing blank lines
        end
        if last >= first then
            found = found + 1
            if found == n then
                local output = text:sub(first, last)
                local _, newlines = output:gsub("\n", "\n")
                local first_row = list[i - 1].row + 1
                return {
                    text = output,
                    lines = newlines + 1,
                    first_row = first_row,
                    last_row = first_row + newlines,
                    rows = rows,
                }
            end
        end
    end
    return nil
end

-- Ask the app that ran the action to perform one of its own actions now.
-- Unlike rex.client.queue, a refusal comes back as nil and a message.
local function perform(ctx, action, args)
    return rex.call("client.perform", {
        client_id = ctx.client_id,
        session_id = ctx.session_id,
        block_id = ctx.block_id,
        action = action,
        args = args,
        timeout_ms = 3000,
    })
end

-- Select rows of the scrollback in the app's copy mode.
local function select_rows(ctx, rows)
    -- Leaving and entering again clears an earlier selection. The app refuses
    -- to leave when it isn't in copy mode, which is fine.
    perform(ctx, "pane.copy_mode.exit")

    local steps = {
        { "pane.copy_mode.enter" },
        { "pane.copy_mode.move", { to = "history_bottom" } },
    }
    local up = rows.rows - rows.last_row
    if up > 0 then
        steps[#steps + 1] = { "pane.copy_mode.move", { to = "up", count = up } }
    end
    steps[#steps + 1] = { "pane.copy_mode.select", { mode = "line" } }
    local height = rows.last_row - rows.first_row
    if height > 0 then
        steps[#steps + 1] = { "pane.copy_mode.move", { to = "up", count = height } }
    end
    for _, step in ipairs(steps) do
        local r, err = perform(ctx, step[1], step[2])
        if r == nil then error(err, 0) end
    end
end

-- Which output each pane's walk is on. A walk ends when the pane prints
-- something new.
local walks = {}

local function signature(text)
    return #text .. ":" .. text:sub(-64)
end

rex.action{
    name = "copy_output",
    title = "Copy Command Output",
    description = "Copies a shell command's output and selects it in copy mode. "
        .. "walk=older or walk=newer steps from the output selected last.",
    keywords = "yank clipboard pbcopy last previous",
    args = { walk = "string?" },
    run = function(ctx, args)
        local text = scrollback(ctx, true)
        local sig = signature(text)
        local walk = walks[ctx.block_id]

        local step = 1
        if args.walk ~= nil and walk ~= nil and walk.sig == sig then
            step = walk.step + (args.walk == "newer" and -1 or 1)
        end
        if step < 1 then
            -- Walked past the newest output: back to the prompt
            walks[ctx.block_id] = nil
            if ctx.client_id ~= nil then
                perform(ctx, "pane.copy_mode.exit")
            end
            return
        end

        local output = nth_output(text, step)
        if output == nil then
            if step > 1 then
                return -- already on the oldest output: stay there
            end
            error("no command output in this pane", 0)
        end
        walks[ctx.block_id] = { step = step, sig = sig }

        local r, err = rex.exec({ "/usr/bin/pbcopy" }, {
            stdin = output.text,
            env = { LC_CTYPE = "UTF-8" },
            timeout = 10,
        })
        if r == nil then error(err, 0) end
        if not r.ok then error("pbcopy failed: " .. r.stderr, 0) end

        -- Only an app can show the selection; from the CLI the copy is enough
        local from_app = ctx.origin == "key" or ctx.origin == "palette"
        if ctx.client_id ~= nil and from_app then
            local rows = nth_output(scrollback(ctx, false), step)
            if rows ~= nil then select_rows(ctx, rows) end
        end
        return { step = step, lines = output.lines, bytes = #output.text }
    end,
}

-- Not shift+cmd+a: macOS reserves it for "Search man Page Index in Terminal"
rex.bind("alt+cmd+c", "copy_output")
rex.bind("ctrl+shift+k", "copy_output", { walk = "older" })
rex.bind("ctrl+shift+j", "copy_output", { walk = "newer" })
