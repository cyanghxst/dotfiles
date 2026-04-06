#!/usr/bin/env bash

if [[ -n "$TMUX" ]]; then
    exit 0
fi

sessions=("main" "obsidian" "homelab" "website" "hackathon")

directories=(
    "$HOME/git/repos/dotfiles/"
    "$HOME/git/repos/obsidian/"
    "$HOME/git/repos/homelab/"
    "$HOME/git/repos/website/"
    "$HOME/git/repos/pe-hackathon/"
)

vault_directory="$HOME/git/repos/vault/"
nvim_directory="$HOME/git/repos/nvim/"
homebrew_tap_directory="$HOME/git/repos/homebrew-cyanghxst/"

for i in "${!sessions[@]}"; do
    session="${sessions[$i]}"
    dir="${directories[$i]}"

    # skip the directory if it's missing
    [[ -d "$dir" ]] || continue

    if ! tmux has-session -t "$session" 2>/dev/null; then

        tmux new-session -d -s "$session" "cd ~; exec zsh"
        tmux new-window -t "$session" "cd $dir; exec zsh"
        tmux send-keys -t "$session" "ls" C-m

        # main: cd to nvim
        if [[ $i -eq 0 && -d "$nvim_directory" ]]; then
            tmux new-window -t "$session" "cd $nvim_directory; exec zsh"
            tmux send-keys -t "$session" "ls" C-m

            tmux new-window -t "$session" "cd $homebrew_tap_directory; exec zsh"
            tmux send-keys -t "$session" "ls" C-m
        fi

        # obsidian: cd to vault
        if [[ $i -eq 1 && -d "$vault_directory" ]]; then
            tmux new-window -t "$session" "cd $vault_directory; exec zsh"
            tmux send-keys -t "$session" "ls" C-m
        fi

        # homelab: ssh into remote
        if [[ $i -eq 2 ]]; then
            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "ssh proxmox" C-m

            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "ssh opnsense" C-m
        fi

        # website: open dev env
        if [[ $i -eq 3 ]]; then
            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "npm run dev" C-m

            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "opencode web" C-m
        fi

        # hackathon: ssh into kube
        if [[ $i -eq 4 ]]; then
            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "ssh optiplex-node1" C-m

            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "ssh optiplex-node2" C-m

            tmux new-window -t "$session" "cd $dir; exec zsh"
            tmux send-keys -t "$session" "ssh optiplex-node3" C-m
        fi
    fi
done

tmux select-window -t main:1
tmux attach -t main
