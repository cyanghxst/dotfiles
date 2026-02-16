#!/usr/bin/env bash

if [[ -n "$TMUX" ]]; then
    exit 0
fi

sessions=("main" "obsidian" "homelab" "cpsc-213")

directories=(
    "$HOME/git/repos/dotfiles/"
    "$HOME/git/repos/obsidian/"
    "$HOME/git/repos/homelab/"
    "$HOME/code/ubc/cpsc-213/"
)

vault_directory="$HOME/git/repos/vault-2/"
nvim_directory="$HOME/git/repos/nvim/"

for i in "${!sessions[@]}"; do
    session="${sessions[$i]}"
    dir="${directories[$i]}"

    # skip the directory if it's missing
    [[ -d "$dir" ]] || continue

    if ! tmux has-session -t "$session" 2>/dev/null; then

        tmux new-session -d -s "$session" "cd ~; exec zsh"
        tmux new-window -t "$session" "cd $dir; exec zsh"
        tmux send-keys -t "$session" "ls" C-m

        if [[ $i -eq 0 && -d "$nvim_directory" ]]; then
            tmux new-window -t "$session" "cd $nvim_directory; exec zsh"
            tmux send-keys -t "$session" "ls" C-m
        fi

        if [[ $i -eq 1 && -d "$vault_directory" ]]; then
            tmux new-window -t "$session" "cd $vault_directory; exec zsh"
            tmux send-keys -t "$session" "ls" C-m
        fi

        # if [[ $i -eq 3 || $i -eq 4 ]]; then
        #     tmux new-window -t "$session" "cd $dir; exec zsh"
        #     tmux send-keys -t "$session" "ls" C-m
        #     tmux send-keys -t "$session" "nf" C-m
        # fi
    fi
done

tmux select-window -t main:1
tmux attach -t main
