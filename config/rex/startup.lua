-- Rex startup layout (https://www.superlogical.com/rex/docs/automate/lua-scripts)
-- Run with: rex-init, or rex do ~/.config/rex/startup.lua
--
-- Creates the sessions below. A session whose label already exists is left
-- alone, so this is safe to run again: it only brings back what is missing.
-- To rebuild one from scratch, kill it first: rex kill homelab

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
            { "dotfiles", pane(dotfiles) },
            { "nvim", pane(nvim) },
        },
    },
    {
        label = "homelab",
        windows = {
            { "repo", pane(homelab) },
            -- The Slurm cluster at a glance: controller and nodes in four
            -- equal rows. Zoom a pane to work in it.
            { "slurm", rows(1 / 4, ssh("slurm-ctl"),
                rows(1 / 3, ssh("optiplex-01"),
                    rows(1 / 2, ssh("optiplex-02"), ssh("optiplex-03")))) },
            { "proxmox", ssh("proxmox") },
        },
    },
}

local function call(method, args)
    local r, err = rex.call(method, args)
    if r == nil then error(method .. ": " .. tostring(err), 0) end
    return r
end

local existing = {}
for _, s in ipairs(call("session.list").sessions or {}) do
    existing[s.label] = s.session_id
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
