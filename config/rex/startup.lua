-- Rex startup layout (https://www.superlogical.com/rex/docs/automate/lua-scripts)
-- Run with: rex-init, or rex do ~/.config/rex/startup.lua
--
-- Creates the sessions below. A session whose label already exists is left
-- alone, so this is safe to run again: it only brings back what is missing.
-- To rebuild one from scratch, kill it first: rex kill homelab
--
-- With reset=true (rex-reset), every session is replaced instead: the ones
-- below are created fresh, then all the sessions that were there before are
-- destroyed, along with everything running in them.
--
-- With tab=LABEL (rex-reset-slurm passes tab=slurm), only that tab is
-- rebuilt, in place, and its session is otherwise left as it is.

local SHELL = "com.superlogical.terminal.shell"

local home = os.getenv("HOME")
local dotfiles = home .. "/code/config/dotfiles"
local nvim = home .. "/code/config/nvim"
local homelab = home .. "/code/projects/homelab"

-- A shell in cwd. run is typed at its prompt rather than started in its
-- place, so the shell is still there when the program ends: a dropped ssh
-- connection leaves a prompt with the command one up-arrow away.
local function pane(cwd, run, label)
    return {
        block = {
            flavor = SHELL,
            label = label,
            options = { cwd = cwd, initial_input = run and (run .. "\n") or nil },
        },
    }
end

-- A shell connected to a host from ~/.ssh/config, labeled with the host so
-- the CLI can target it: rex send -s homelab -b optiplex-01 'uptime'
local function ssh(host)
    return pane(homelab, "ssh " .. host, host)
end

local columns, rows = rex.layout.horizontal, rex.layout.vertical

-- Each window is { label, layout }. The first window of a session, and the
-- first pane of that window, are the ones focused.
local sessions = {
    {
        label = "config",
        windows = {
            { "dotfiles", pane(dotfiles, "git lol") },
            { "nvim", pane(nvim, "git lol") },
        },
    },
    {
        label = "homelab",
        windows = {
            { "repo", pane(homelab) },
            -- The Slurm cluster at a glance: controller and nodes in a grid.
            -- Zoom a pane to work in it.
            { "slurm", columns(0.5,
                rows(0.5, ssh("slurm-ctl"), ssh("optiplex-02")),
                rows(0.5, ssh("optiplex-01"), ssh("optiplex-03"))) },
            { "proxmox", ssh("proxmox") },
        },
    },
}

local function call(method, args)
    local r, err = rex.call(method, args)
    if r == nil then error(method .. ": " .. tostring(err), 0) end
    return r
end

-- Put a fresh copy of the tab called label where the old one is, then close
-- the old one and everything running in it. The old tab closes last because
-- this script may be running in it.
local function rebuild_tab(label)
    for _, s in ipairs(sessions) do
        for _, w in ipairs(s.windows) do
            if w[1] == label then
                local session_id
                for _, running in ipairs(call("session.list").sessions or {}) do
                    if running.label == s.label then session_id = running.session_id end
                end
                if session_id == nil then
                    error("the " .. s.label .. " session is not running; run rex-init", 0)
                end

                local old = {}
                local view = call("session.attach", { session_id = session_id }).view
                for _, window in ipairs(view.windows or {}) do
                    if window.label == label then old[#old + 1] = window.window_id end
                end

                local created = call("session.new_window", {
                    session_id = session_id,
                    window_label = label,
                    layout = w[2],
                })
                if old[1] then
                    call("session.move_window", {
                        session_id = session_id,
                        window_id = created.window_id,
                        before_window_id = old[1],
                    })
                end
                call("session.focus_block", {
                    session_id = session_id,
                    block_id = created.block_ids[1],
                })
                print(s.label .. ": rebuilt the " .. label .. " tab")
                for _, window_id in ipairs(old) do
                    call("session.close_window", { session_id = session_id, window_id = window_id })
                end
                return
            end
        end
    end
    error("the startup layout has no tab called " .. label, 0)
end

if rex.args.tab ~= nil then
    rebuild_tab(rex.args.tab)
    return
end

local reset = rex.args.reset == true
local existing, old = {}, {}
for _, s in ipairs(call("session.list").sessions or {}) do
    if reset then
        old[#old + 1] = s
    else
        existing[s.label] = s.session_id
    end
end

local first_session
for _, s in ipairs(sessions) do
    local session_id = existing[s.label]
    if session_id then
        print(s.label .. ": already running")
    else
        local windows = {}
        for i, w in ipairs(s.windows) do
            windows[i] = { window_label = w[1], layout = w[2] }
        end
        local created = call("session.create", { label = s.label, initial_windows = windows })
        session_id = created.session_id
        -- session.create leaves the last window active, and only a
        -- connection attached to the session may move its focus
        call("session.attach", { session_id = session_id })
        call("session.focus_block", {
            session_id = session_id,
            block_id = created.initial_windows[1].block_ids[1],
        })
        print(s.label .. ": created")
    end
    first_session = first_session or session_id
end

-- Show the first session in the app. This needs an app with Remote Control
-- turned on; without one, pick the session from the sidebar instead.
if rex.args.select ~= false then
    pcall(rex.client.queue, "session.select", { session_id = first_session })
end

-- The old sessions go only now, so the server is never left without one, and
-- the session this script runs in goes last: its terminal, and the script
-- with it, ends there.
table.sort(old, function(a, b)
    return a.session_id ~= rex.session_id and b.session_id == rex.session_id
end)
for _, s in ipairs(old) do
    print(s.label .. ": destroyed")
    call("session.destroy", { session_id = s.session_id })
end
