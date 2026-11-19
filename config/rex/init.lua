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
-- Select a command's output
-- ----------------------------------------
--
-- The same walk as C-S-k / C-S-j in tmux.conf: select the last command's
-- output in copy mode, then step to older or newer outputs. Yank with y.
--
-- Rex's capture drops OSC 133 marks, so prompts are found by their text, the
-- same two kinds as in tmux.conf:
--   * the local zsh prompt, whose last line has a no-break space as its second
--     character and a path line (and usually a blank line) above it
--     (see zsh/prompt.zsh)
--   * a one-line "user@host:path$ " prompt, the bash default on remote hosts
-- Change these, and their twins in tmux.conf, if a prompt changes.
--
-- When tmux is running in the pane, the key is passed on so tmux's own binding
-- handles it.

local TERMINAL = "com.superlogical.terminal"
local LOCAL_PROMPT = "^[^\n\128-\191][\128-\191]*\194\160" -- one character, then U+00A0
-- Shells started before the prompt gained its no-break space still end it in a
-- plain space, so the prompt's own glyph (U+F140B) counts as well
local OLD_LOCAL_PROMPT = "^\243\177\144\139 "
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
    if text:find(LOCAL_PROMPT, pos) or text:find(OLD_LOCAL_PROMPT, pos) then
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
-- prompt's upper lines or the blank lines above them. With no prompt below,
-- the command is still running and its output runs to the end of the text.
local function output_end(text, first, below)
    local last = below and below.pos - 2 or #text
    for _ = 1, below and below.above or 0 do
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
-- command line above it; the newest may belong to a command that is still
-- running, with no prompt below it yet. back says how many prompts from the
-- end the output's lower prompt is, or -1 when it has none.
local function nth_output(text, n)
    local list = prompts(text)
    local found = 0
    for i = #list + 1, 2, -1 do
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
    local limit = list[i] and list[i].pos or #text + 1
    local have, pos, row = 0, list[i - 1].pos, list[i - 1].row
    local nl
    while true do
        nl = text:find("\n", pos, true) or (#text + 1)
        have = have + solid_length(text:sub(pos, nl - 1))
        if have >= need or nl + 1 >= limit then break end
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

-- Select rows of the scrollback in the app's copy mode. The app must not be
-- in copy mode yet.
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

-- Programs that take over the screen and may be running tmux: tmux itself, or
-- a remote shell with tmux inside it.
local TMUX_HOSTS = { tmux = true, ssh = true, mosh = true, ["mosh-client"] = true }
local ALT_SCREEN = { [47] = true, [1047] = true, [1049] = true }
-- Ctrl+Shift+k and Ctrl+Shift+j as tmux reads them with extended-keys on
local TMUX_KEYS = { older = "\27[107;6u", newer = "\27[106;6u" }

-- Hand the key to tmux when the pane is on the alternate screen under one of
-- TMUX_HOSTS. Returns whether it did.
local function pass_to_tmux(ctx, walk)
    local key = TMUX_KEYS[walk]
    if key == nil then return false end

    local process = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
    local name = process and process.foreground and process.foreground.name
    if not TMUX_HOSTS[name] then return false end

    local modes = rex.block.call(TERMINAL, "modes", { block_id = ctx.block_id })
    for _, mode in ipairs(modes and modes.modes or {}) do
        if ALT_SCREEN[mode.number] and mode.set then
            local r, err = rex.block.call(TERMINAL, "write", {
                block_id = ctx.block_id,
                data = key,
            })
            if r == nil then error(err, 0) end
            return true
        end
    end
    return false
end

-- Which output each pane's walk is on. A walk ends when the pane prints
-- something new.
local walks = {}

local function signature(text)
    return #text .. ":" .. text:sub(-64)
end

rex.action{
    name = "select_output",
    title = "Select Command Output",
    description = "Selects a shell command's output in copy mode. "
        .. "walk=older or walk=newer steps from the output selected last.",
    keywords = "copy yank last previous",
    args = { walk = "string?" },
    run = function(ctx, args)
        -- Only an app can show a selection; from the CLI the output is copied
        local from_app = ctx.client_id ~= nil
            and (ctx.origin == "key" or ctx.origin == "palette")

        if from_app and pass_to_tmux(ctx, args.walk) then return end

        -- A walk continues only while the app is still in copy mode, as in
        -- tmux. The app refuses copy mode's motions when it isn't in it, which
        -- tells the two apart; moving to the start of the line leaves a line
        -- selection as it is.
        local in_copy_mode = from_app
            and perform(ctx, "pane.copy_mode.move", { to = "line_start" }) ~= nil
        local walking = in_copy_mode or not from_app
        if from_app and not walking and args.walk == "newer" then
            return -- nothing newer than the prompt
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
            if in_copy_mode then perform(ctx, "pane.copy_mode.exit") end
            return
        end

        local output = nth_output(text, step)
        if output == nil and step > 1 then
            return -- already on the oldest output: leave it selected
        end
        if output == nil then
            if from_app then return end -- nothing to select, as in tmux
            error("no command output in this pane", 0)
        end
        walks[ctx.block_id] = { step = step, sig = sig }

        if from_app then
            local rows = output_rows(scrollback(ctx, false), output)
            if rows ~= nil then
                -- Leaving copy mode clears the earlier selection
                if in_copy_mode then perform(ctx, "pane.copy_mode.exit") end
                select_rows(ctx, rows)
            end
        else
            local r, err = rex.exec({ "/usr/bin/pbcopy" }, {
                stdin = output.text,
                env = { LC_CTYPE = "UTF-8" },
                timeout = 10,
            })
            if r == nil then error(err, 0) end
            if not r.ok then error("pbcopy failed: " .. r.stderr, 0) end
        end
        return { step = step, lines = output.lines, bytes = #output.text }
    end,
}

-- The same keys as tmux: the first press selects the last output
rex.bind("ctrl+shift+k", "select_output", { walk = "older" })
rex.bind("ctrl+shift+j", "select_output", { walk = "newer" })

-- ----------------------------------------
-- SSH to a host
-- ----------------------------------------
--
-- Pick a host from ~/.ssh/config in the command palette, or type any other
-- destination, and open it in a new tab. As in startup.lua, ssh is typed at a
-- shell's prompt, so a dropped connection leaves a prompt to reconnect from.

-- The hosts worth a shell: every Host that is a name rather than a pattern,
-- except the ones that log in as git.
local function ssh_hosts()
    local file = io.open(os.getenv("HOME") .. "/.ssh/config")
    if file == nil then return {} end

    local hosts, seen, current = {}, {}, {}
    for line in file:lines() do
        local key, value = line:match("^%s*(%a+)[%s=]+(.-)%s*$")
        key = key and key:lower()
        if key == "host" or key == "match" then
            current = {}
            for name in (key == "host" and value or ""):gmatch("%S+") do
                if not name:find("[*?!]") and not seen[name] then
                    seen[name] = true
                    current[#current + 1] = { name = name }
                    hosts[#hosts + 1] = current[#current]
                end
            end
        elseif key == "user" or key == "hostname" then
            for _, host in ipairs(current) do
                host[key] = host[key] or value -- ssh keeps the first value
            end
        end
    end
    file:close()

    local items = {}
    for _, host in ipairs(hosts) do
        if host.user ~= "git" then
            local address = host.hostname or host.name
            items[#items + 1] = {
                id = host.name,
                subtitle = host.user and (host.user .. "@" .. address) or address,
                icon = "server",
            }
        end
    end
    return items
end

rex.action{
    name = "ssh_host",
    title = "SSH to Host…",
    description = "Opens a tab connected to a host from ~/.ssh/config. "
        .. "host=NAME skips the question.",
    keywords = "ssh remote server homelab connect",
    args = { host = "string?" },
    run = function(ctx, args)
        local host = args.host
        if host == nil then
            if rex.ui == nil then
                error("this Rex server is too old to ask for a host; pass host=NAME", 0)
            end
            local why, detail
            host, why, detail = rex.ui.pick{
                title = "SSH to host",
                placeholder = "Filter hosts, or type a destination",
                items = ssh_hosts(),
                allow_other = true,
            }
            if host == nil then
                if why == "cancelled" then return end
                error("could not ask for a host: " .. why
                    .. (detail and (" (" .. detail .. ")") or ""), 0)
            end
            if type(host) == "table" then host = host.text end
        end

        local w, err = rex.session.new_window{
            window_label = host,
            layout = {
                block = {
                    flavor = TERMINAL .. ".shell",
                    label = host,
                    options = { initial_input = "ssh " .. host .. "\n" },
                },
            },
        }
        if w == nil then error(err, 0) end
        return { host = host, window_id = w.window_id }
    end,
}
