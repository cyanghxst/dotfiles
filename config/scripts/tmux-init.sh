#!/bin/bash

if [ -n "$TMUX" ]; then
    exit 0
fi

sessions=("main" "dsa" "1160" "1181" "1280")

directories=(
    "$HOME/git/repos/dotfiles/"
    "$HOME/code/dsa"
    "$HOME/code/langara/cpsc-1160"
    "$HOME/code/langara/cpsc-1181"
    "$HOME/code/langara/cpsc-1280"
)

for i in "${!sessions[@]}"; do
    session="${sessions[$i]}"
    dir="${directories[$i]}"

    tmux has-session -t "$session" 2>/dev/null

    if [ $? != 0 ]; then
        tmux new-session -d -s "$session" "cd ~; exec zsh"
        tmux new-window -t "$session:1" "cd $dir; exec zsh"
        tmux send-keys -t "$session:1" "ls" C-m
    fi
done

tmux attach -t main
