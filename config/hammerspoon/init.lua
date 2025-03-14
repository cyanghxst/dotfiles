local last_state = nil -- Keep track of the previous monitor state

local function app_running(app_name)
	local app = hs.application.get(app_name)
	return app ~= nil
end

local function restart_app_if_open(app_name)
	local app = hs.application.get(app_name)
	if app then
		app:kill()
		hs.timer.doAfter(1, function()
			hs.application.open(app_name)

			-- Poll until the app opens, then center it
			local poll_timer = hs.timer.doEvery(0.1, function()
				local running_app = hs.application.get(app_name)
				if running_app and running_app:mainWindow() then
					poll_timer:stop()
					center_window(app_name)
				end
			end)
		end)
	end
end

local function center_window(app_name)
	local app = hs.application.get(app_name)
	if app then
		local win = app:mainWindow()
		if win then
			local screen = win:screen()
			if screen then
				local screen_frame = screen:frame() -- Get screen size
				local win_frame = win:frame() -- Get window size

				-- Calculate centered position
				local new_x = screen_frame.x + (screen_frame.w - win_frame.w) / 2
				local new_y = screen_frame.y + (screen_frame.h - win_frame.h) / 2

				-- Move the window only if necessary
				if win:frame().x ~= new_x or win:frame().y ~= new_y then
					win:setFrame({ x = new_x, y = new_y, w = win_frame.w, h = win_frame.h })
				end
			end
		end
	end
end

local function update_terminal_config()
	local is_external_connected = #hs.screen.allScreens() > 1 -- Detect external monitor
	local power_source = hs.battery.powerSource() -- Battery vs AC
	local current_state = is_external_connected and "external" or "laptop"

	-- **Prevent relaunching if the state hasn't changed**
	if last_state == current_state then
		return
	end
	last_state = current_state -- Update state

	-- Config file paths
	local ghostty_config = "/Users/cyanghxst/git/repos/dotfiles/config/ghostty/config"
	local kitty_config = "/Users/cyanghxst/git/repos/dotfiles/config/kitty/kitty.conf"

	-- **Apply settings only if necessary**
	if is_external_connected or power_source == "AC Power" then
		hs.execute("sed -i '' 's/^font-size = 14/# font-size = 14/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# font-size = 15/font-size = 15/' " .. ghostty_config)

		hs.execute("sed -i '' 's/^font_size 14/# font_size 14/' " .. kitty_config)
		hs.execute("sed -i '' 's/^# font_size 15/font_size 15/' " .. kitty_config)

		hs.execute("sed -i '' 's/^# window-height = 42/window-height = 42/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-width = 173/window-width = 173/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-height = 38/# window-height = 38/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-width = 149/# window-width = 149/' " .. ghostty_config)

		-- Padding
		hs.execute("sed -i '' 's/^# window-padding-x = 27/window-padding-x = 27/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-padding-y = 15/window-padding-y = 15/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-padding-x = 28/# window-padding-x = 28/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-padding-y = 17/# window-padding-y = 17/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-padding-balance = true/window-padding-balance = true/' " .. ghostty_config)

		hs.execute("sed -i '' 's/^# initial_window_width 177c/initial_window_width 177c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^# initial_window_height 44c/initial_window_height 44c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^initial_window_width 152c/# initial_window_width 152c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^initial_window_height 39c/# initial_window_height 39c/' " .. kitty_config)
	else
		hs.execute("sed -i '' 's/^font-size = 15/# font-size = 14/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# font-size = 14/font-size = 14/' " .. ghostty_config)

		hs.execute("sed -i '' 's/^font_size 15/font_size 14/' " .. kitty_config)
		hs.execute("sed -i '' 's/^# font_size 14/font_size 14/' " .. kitty_config)

		hs.execute("sed -i '' 's/^window-height = 42/# window-height = 42/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-width = 173/# window-width = 173/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-height = 38/window-height = 38/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-width = 149/window-width = 149/' " .. ghostty_config)

		-- Padding
		hs.execute("sed -i '' 's/^window-padding-x = 27/# window-padding-x = 27/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-padding-y = 15/# window-padding-y = 15/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-padding-x = 28/window-padding-x = 28/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^# window-padding-y = 17/window-padding-y = 17/' " .. ghostty_config)
		hs.execute("sed -i '' 's/^window-padding-balance = true/# window-padding-balance = true/' " .. ghostty_config)

		hs.execute("sed -i '' 's/^initial_window_width 177c/# initial_window_width 177c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^initial_window_height 44c/# initial_window_height 44c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^# initial_window_width 152c/initial_window_width 152c/' " .. kitty_config)
		hs.execute("sed -i '' 's/^# initial_window_height 39c/initial_window_height 39c/' " .. kitty_config)
	end

	-- **Only restart apps if they are already running**
	restart_app_if_open("Ghostty")
	restart_app_if_open("kitty")

	-- **Ensure windows are centered properly**
	hs.timer.doAfter(2, function()
		center_window("Ghostty")
		center_window("kitty")
	end)

	-- Notify user
	hs.notify
		.new({
			title = "Terminal Updated",
			informativeText = "Switched to " .. (is_external_connected and "External Monitor" or "Laptop Mode"),
		})
		:send()
end

-- Watch for screen layout changes and power source changes
screen_watcher = hs.screen.watcher.new(update_terminal_config)
battery_watcher = hs.battery.watcher.new(update_terminal_config)

screen_watcher:start()
battery_watcher:start()

-- Run immediately on startup
update_terminal_config()
