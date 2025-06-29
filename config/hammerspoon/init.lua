local last_state = nil -- Keep track of the previous monitor state

-- App-related Functions
local function app_running(app_name)
	return hs.application.get(app_name) ~= nil
end

local function center_window(app_name)
	local app = hs.application.get(app_name)
	if not app then
		return
	end

	local win = app:mainWindow()
	if not win then
		return
	end

	local screen = win:screen()
	if not screen then
		return
	end

	local screen_frame = screen:frame()
	local win_frame = win:frame()

	local new_x = screen_frame.x + (screen_frame.w - win_frame.w) / 2
	local new_y = screen_frame.y + (screen_frame.h - win_frame.h) / 2

	if win:frame().x ~= new_x or win:frame().y ~= new_y then
		win:setFrame({ x = new_x, y = new_y, w = win_frame.w, h = win_frame.h })
	end
end

local function restart_app_if_open(app_name)
	local app = hs.application.get(app_name)
	if not app then
		return
	end

	app:kill()
	hs.timer.doAfter(1, function()
		hs.application.open(app_name)
		local poll_timer = hs.timer.doEvery(0.1, function()
			local running_app = hs.application.get(app_name)
			if running_app and running_app:mainWindow() then
				poll_timer:stop()
				center_window(app_name)
			end
		end)
	end)
end

-- Configuration Management
local function set_config_value(file_path, key, active_value, inactive_value, is_active)
	local value_to_set = is_active and active_value or inactive_value
	local value_to_unset = is_active and inactive_value or active_value

	-- Ensure the inactive value is commented out and the active one is not
	hs.execute(
		string.format("sed -i '' 's/^%s = %s/# %s = %s/' %s", key, value_to_unset, key, value_to_unset, file_path)
	)
	hs.execute(string.format("sed -i '' 's/^# %s = %s/%s = %s/' %s", key, value_to_set, key, value_to_set, file_path))
end

local function set_kitty_config_value(file_path, key, active_value, inactive_value, is_active)
	local value_to_set = is_active and active_value or inactive_value
	local value_to_unset = is_active and inactive_value or active_value

	-- Ensure the inactive value is commented out and the active one is not
	hs.execute(string.format("sed -i '' 's/^%s %s/# %s %s/' %s", key, value_to_unset, key, value_to_unset, file_path))
	hs.execute(string.format("sed -i '' 's/^# %s %s/%s %s/' %s", key, value_to_set, key, value_to_set, file_path))
end

local HOME = os.getenv("HOME")
local dotfiles_path = HOME .. "/git/repos/dotfiles/config/"

local terminal_configs = {
	ghostty = {
		path = dotfiles_path .. "ghostty/config",
		set_value = set_config_value,
		settings = {
			{ key = "font-size", active = 15, inactive = 14 },
			{ key = "window-height", active = 42, inactive = 38 },
			{ key = "window-width", active = 173, inactive = 149 },
			{ key = "window-padding-x", active = 27, inactive = 28 },
			{ key = "window-padding-y", active = 15, inactive = 17 },
			{ key = "window-padding-balance", active = "true", inactive = "false" },
		},
	},
	kitty = {
		path = dotfiles_path .. "kitty/kitty.conf",
		set_value = set_kitty_config_value,
		settings = {
			{ key = "font_size", active = 15, inactive = 14 },
			{ key = "initial_window_width", active = "177c", inactive = "152c" },
			{ key = "initial_window_height", active = "44c", inactive = "39c" },
		},
	},
}

-- Main Logic
local function update_terminal_config()
	local is_external_connected = #hs.screen.allScreens() > 1
	local power_source = hs.battery.powerSource()
	local current_state = (is_external_connected or power_source == "AC Power") and "external" or "laptop"

	if last_state == current_state then
		return
	end
	last_state = current_state

	local is_active = current_state == "external"

	for _, config in pairs(terminal_configs) do
		for _, setting in ipairs(config.settings) do
			config.set_value(config.path, setting.key, setting.active, setting.inactive, is_active)
		end
	end

	restart_app_if_open("Ghostty")
	restart_app_if_open("kitty")

	hs.timer.doAfter(2, function()
		center_window("Ghostty")
		center_window("kitty")
	end)

	hs.notify
		.new({
			title = "Terminal Updated",
			informativeText = "Switched to " .. (is_active and "External Monitor" or "Laptop Mode"),
		})
		:send()
end

-- Watchers
local screen_watcher = hs.screen.watcher.new(update_terminal_config)
local battery_watcher = hs.battery.watcher.new(update_terminal_config)

screen_watcher:start()
battery_watcher:start()

-- Initial run
update_terminal_config()
