#!/usr/bin/env bash

# ssh to a host, taking turns with other ssh-queue calls for the 1Password
# approval. rex-reset opens several ssh panes at once; 1Password shows one
# prompt and parks the rest in the menu bar, where they time out after a
# minute and the agent answers "agent refused operation".
#
# Under the lock, `ssh host true` opens the ControlMaster connection, which
# ControlPersist keeps alive in the background. The real session then reuses
# it without asking again. If that step fails, the real ssh still runs, so
# the pane shows the error and the command is one up-arrow away.
#
# usage: ssh-queue HOST [ssh args...]

host="${1:?usage: ssh-queue HOST [ssh args...]}"
lock="$HOME/.ssh/cm/.approval.lock"
mkdir -p "${lock%/*}"

lockf -t 300 "$lock" ssh -n "$host" true
exec ssh "$@"
