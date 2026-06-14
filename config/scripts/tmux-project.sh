#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Usage: $(basename "$0") <project-path>"
    exit 1
fi

input="$1"
case "$input" in
    "~") input="$HOME" ;;
    "~/"*) input="$HOME/${input#\~/}" ;;
esac

project_dir="$(realpath "$input")"

if [[ ! -d "$project_dir" ]]; then
    echo "Error: '$project_dir' is not a directory"
    exit 1
fi

session="$(basename "$project_dir")"

attach_or_switch() {
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$1"
    else
        tmux attach -t "$1"
    fi
}

if tmux has-session -t "$session" 2>/dev/null; then
    attach_or_switch "$session"
    exit 0
fi

# window 1: home directory
tmux new-session -d -s "$session" "cd ~; exec zsh"

# window 2: project directory with git lol or ls fallback
if [[ -d "$project_dir/.git" ]]; then
    tmux new-window -t "$session" "cd $project_dir; exec zsh -c 'git lol; exec zsh'"
else
    tmux new-window -t "$session" "cd $project_dir; exec zsh"
    tmux send-keys -t "$session" "ls" C-m
fi

# window 3: project directory with ls
tmux new-window -t "$session" "cd $project_dir; exec zsh"
tmux send-keys -t "$session" "ls" C-m

tmux select-window -t "$session:1"
attach_or_switch "$session"
