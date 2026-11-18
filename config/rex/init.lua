-- Rex configuration (https://www.superlogical.com/rex/docs/customize/config)
-- Apply changes with: rex config reload

-- Sidebar
rex.unbind("cmd+/", "client.sidebar.toggle")
rex.bind("cmd+s", "client.sidebar.toggle")

-- Quick switcher (experimental)
rex.bind("shift+cmd+\\", "client.setting.developer.experimental.new_quick_switcher")

-- Karabiner turns caps lock into control when held and escape when tapped, so
-- shift + a caps lock tap (an abandoned ctrl+shift chord, say) is shift+escape.
-- Rex encodes that as CSI 27;2;27~, which zsh prints as ";2;27~". Send a plain
-- escape instead.
rex.bind("shift+escape", "pane.send_key", { key = "escape" })

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

-- Where an output ends: the byte before the prompt below it, without that
-- prompt's upper lines or the blank lines above them.
local function output_end(text, first, below)
    local last = below.pos - 2
    for _ = 1, below.above do
        while last >= first and text:byte(last) ~= NEWLINE do
            last = last - 1 -- drop a line of the prompt below
        end
        last = last - 1
    end
    while last >= first and BLANK[text:byte(last)] do
        last = last - 1 -- drop trailing blank lines
    end
    return last
end

-- The nth newest command output in unwrapped text, skipping commands that
-- printed nothing. An output is the text between two prompts, without the
-- command line above it. back says how many prompts from the end it is.
local function nth_output(text, n)
    local list = prompts(text)
    local found = 0
    for i = #list, 2, -1 do
        local first = list[i - 1].nl + 1
        local last = output_end(text, first, list[i])
        if last >= first then
            found = found + 1
            if found == n then
                local output = text:sub(first, last)
                local _, newlines = output:gsub("\n", "\n")
                return {
                    text = output,
                    lines = newlines + 1,
                    command = text:sub(list[i - 1].pos, list[i - 1].nl - 1),
                    back = #list - i,
                }
            end
        end
    end
    return nil
end

local function solid_length(s)
    local solid = s:gsub("%s", "")
    return #solid
end

-- The terminal rows the same output covers in text that is not unwrapped. A
-- long command line wraps over several rows; they are skipped by counting its
-- characters, since copy mode's line selection takes a whole wrapped line.
local function output_rows(text, output)
    local list, rows = prompts(text)
    local i = #list - output.back
    if i < 2 then return nil end

    local need = solid_length(output.command)
    local have, pos, row = 0, list[i - 1].pos, list[i - 1].row
    local nl
    while true do
        nl = text:find("\n", pos, true) or (#text + 1)
        have = have + solid_length(text:sub(pos, nl - 1))
        if have >= need or nl + 1 >= list[i].pos then break end
        pos, row = nl + 1, row + 1
    end

    local first = nl + 1
    local last = output_end(text, first, list[i])
    if last < first then return nil end
    local _, newlines = text:sub(first, last):gsub("\n", "\n")
    return { first_row = row + 1, last_row = row + 1 + newlines, rows = rows }
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

-- Select rows of the scrollback in the app's copy mode. The caller has left
-- copy mode already, which cleared any earlier selection.
local function select_rows(ctx, rows)
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
        -- Only an app can show the selection; from the CLI the copy is enough
        local from_app = ctx.client_id ~= nil
            and (ctx.origin == "key" or ctx.origin == "palette")

        -- A walk continues only while the app is still in copy mode, as in
        -- tmux. The app refuses to leave copy mode when it isn't in it, which
        -- tells the two apart; leaving also clears the earlier selection.
        local walking = true
        if from_app then
            walking = perform(ctx, "pane.copy_mode.exit") ~= nil
            if not walking and args.walk == "newer" then
                return -- nothing newer than the prompt
            end
        end

        local text = scrollback(ctx, true)
        local sig = signature(text)
        local walk = walks[ctx.block_id]

        local step = 1
        if walking and args.walk ~= nil and walk ~= nil and walk.sig == sig then
            step = walk.step + (args.walk == "newer" and -1 or 1)
        end
        if step < 1 then
            -- Walked past the newest output: back to the prompt
            walks[ctx.block_id] = nil
            return
        end

        local output = nth_output(text, step)
        if output == nil and step > 1 then
            step = step - 1 -- already on the oldest output: stay there
            output = nth_output(text, step)
        end
        if output == nil then
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

        if from_app then
            local rows = output_rows(scrollback(ctx, false), output)
            if rows ~= nil then select_rows(ctx, rows) end
        end
        return { step = step, lines = output.lines, bytes = #output.text }
    end,
}

-- The same keys as tmux: the first press selects the last output
rex.bind("ctrl+shift+k", "copy_output", { walk = "older" })
rex.bind("ctrl+shift+j", "copy_output", { walk = "newer" })
