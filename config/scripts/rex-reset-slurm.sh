#!/usr/bin/env bash

# Rebuild the slurm tab of the homelab session from config/rex/startup.lua:
# fresh ssh connections to the controller and the nodes, in the same place.
# Everything running in the old tab ends. The other tabs are left alone.
exec rex do "${XDG_CONFIG_HOME:-$HOME/.config}/rex/startup.lua" tab=slurm "$@"
