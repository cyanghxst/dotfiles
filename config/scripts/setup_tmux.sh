#!/bin/bash

# Exit if running inside tmux already
if [ -n "$TMUX" ]; then
    exit 0
fi

# Define session names
sessions=("main" "cpp" "1160" "1181" "1280")

# Define directories for each session's second window
directories=(
    "$HOME/git/repos/dotfiles/"      # Main session (dotfiles directory)
    "$HOME/code/learn-cpp"           # cpp session directory
    "$HOME/code/langara/cpsc-1160"   # 1160 session directory
    "$HOME/code/langara/cpsc-1181"   # 1181 session directory
    "$HOME/code/langara/cpsc-1280"   # 1280 session directory
)

# Create tmux session and windows if they don't exist
for i in "${!sessions[@]}"; do
    session="${sessions[$i]}"
    dir="${directories[$i]}"

    # Check if the session already exists
    tmux has-session -t "$session" 2>/dev/null

    # If session doesn't exist, create it
    if [ $? != 0 ]; then
        # Create new session with home directory in the first window using zsh
        tmux new-session -d -s "$session" "cd ~; exec zsh"
        # Create second window with specific directory using zsh
        tmux new-window -t "$session:1" "cd $dir; exec zsh"
        # Set up git graph alias 'lol' (if not already set)
        tmux send-keys -t "$session:1" "git lol" C-m
    fi
done

# Attach to the 'main' session if not already attached
tmux attach -t main
