#!/usr/bin/env bash

# Build the Rex sessions laid out in config/rex/startup.lua. Sessions that are
# already running are left alone.
exec rex do "${XDG_CONFIG_HOME:-$HOME/.config}/rex/startup.lua" "$@"
