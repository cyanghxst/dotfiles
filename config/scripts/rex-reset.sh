#!/usr/bin/env bash

# Replace every Rex session with fresh ones from config/rex/startup.lua. This
# ends everything running in the current sessions, so it asks first; pass -y
# to skip the question.
if [[ "$1" == "-y" ]]; then
    shift
else
    rex ls
    read -r -p "Destroy every session above and rebuild? [y/N] " answer
    [[ "$answer" == [yY]* ]] || exit 1
fi

exec rex do "${XDG_CONFIG_HOME:-$HOME/.config}/rex/startup.lua" reset=true "$@"
