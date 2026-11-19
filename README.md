# dotfiles

Personal macOS configuration, managed with [Dotbot](https://github.com/anishathalye/dotbot). Every config lives under `config/` and is symlinked into place by `./install`.

## Structure

```bash
.
├── .dotbot/            # Dotbot (git submodule)
├── .install.conf.yaml  # Dotbot config: which file links where
├── install             # Entry point: syncs submodules, runs Dotbot
├── LICENSE
├── config/             # All tool configs, one directory per tool
└── docs/               # Notes on custom keybindings
```

## Config

```bash
config/
├── 1password/          # 1Password SSH agent config
├── alacritty/          # Alacritty terminal
├── btop/               # btop
├── clangd/             # clangd config and clang-format
├── fastfetch/          # fastfetch
├── gh/                 # GitHub CLI (hosts.yml is untracked)
├── ghostty/            # Ghostty terminal, plus cursor shaders submodule
├── git/                # gitconfig and global ignore
├── htop/               # htop
├── java/               # checkstyle and jdtls formatter settings
├── karabiner/          # Karabiner-Elements: caps lock as control/escape, app-specific remaps
├── kitty/              # Kitty terminal and themes
├── lftp/               # lftp
├── mise/               # mise tool versions
├── neofetch/           # neofetch
├── opencode/           # opencode
├── rex/                # Rex init.lua: shortcuts and the select_output action
├── scripts/            # Helper scripts, linked into ~/.local/bin
├── tldr/               # tldr (tlrc) client
├── tmux/               # tmux.conf
├── vim/                # vimrc
└── zsh/                # zshrc, zprofile, prompt, functions
```

## Install

> [!WARNING]
> These dotfiles are tailored to my setup and may overwrite your existing configs. Use them as a reference and borrow what you need. Install at your own risk.

1. Clone the repo with its submodules:

```bash
git clone --recurse-submodules <repo-url> ~/code/config/dotfiles
```

2. Move into the repo:

   
```bash
cd ~/code/config/dotfiles
```

3. Run the installer:

   
```bash
./install
```

## How Dotbot links configs

- Most directories in `config/` follow the XDG convention and are linked into `~/.config/<name>` (`$XDG_CONFIG_HOME`).
- Tools that expect a file elsewhere (`~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`, `~/.vimrc`, etc.) are linked individually; see `.install.conf.yaml`.
- `config/zsh/*` (except `zshrc` and `zprofile`) is linked into `~/.zsh/`.

## Custom keybindings

Caps lock doubles as Control and Escape, and `Ctrl+Shift+k` / `Ctrl+Shift+j` select a previous command's output in tmux and Rex. See [docs/keybindings.md](docs/keybindings.md) for details.

## License

This dotfiles repo is licensed under the [MIT License](LICENSE).
