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

new_window() {
    local session="$1"
    local dir="$2"
    local cmd="$3"

    if [[ -n "$cmd" ]]; then
        tmux new-window -t "$session" "cd $dir; exec zsh -c '$cmd; exec zsh'"
    else
        tmux new-window -t "$session" "cd $dir; exec zsh"
        tmux send-keys -t "$session" "ls" C-m
    fi
}

for i in "${!sessions[@]}"; do
    session="${sessions[$i]}"
    dir="${directories[$i]}"

    [[ -d "$dir" ]] || continue

    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" "cd ~; exec zsh"
        new_window "$session" "$dir"

        # main
        if [[ $i -eq 0 ]]; then
            [[ -d "$nvim_directory" ]] && new_window "$session" "$nvim_directory"
            [[ -d "$homebrew_tap_directory" ]] && new_window "$session" "$homebrew_tap_directory"
        fi

        # obsidian
        if [[ $i -eq 1 ]]; then
            [[ -d "$vault_directory" ]] && new_window "$session" "$vault_directory"
        fi

        # homelab
        if [[ $i -eq 2 ]]; then
            new_window "$session" "$dir" "ssh proxmox"
            new_window "$session" "$dir" "ssh opnsense"
        fi

        # website
        if [[ $i -eq 3 ]]; then
            new_window "$session" "$dir" "npm run dev"
            new_window "$session" "$dir" "opencode web"
        fi

        # hackathon
        if [[ $i -eq 4 ]]; then
            new_window "$session" "$dir" "ssh optiplex-node1"
            new_window "$session" "$dir" "ssh optiplex-node2"
            new_window "$session" "$dir" "ssh optiplex-node3"
        fi
    fi
done

tmux select-window -t main:1
tmux attach -t main
