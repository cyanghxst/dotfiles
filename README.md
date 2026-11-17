# dotfiles

Personal macOS configuration, managed with [Dotbot](https://github.com/anishathalye/dotbot). Every config lives under `config/` and is symlinked into place by `./install`.

## Structure

```bash
.
├── .dotbot/            # Dotbot (git submodule)
├── .install.conf.yaml  # Dotbot config: which file links where
├── install             # Entry point: syncs submodules, runs Dotbot
├── LICENSE
└── config/             # All tool configs, one directory per tool
```

## Config

```bash
config/
├── 1password/          # 1Password SSH agent config
├── aider/              # aider.conf.yml
├── alacritty/          # Alacritty terminal
├── btop/               # btop
├── clangd/             # clangd config and clang-format
├── fastfetch/          # fastfetch
├── gh/                 # GitHub CLI (hosts.yml is untracked)
├── ghostty/            # Ghostty terminal, plus cursor shaders submodule
├── git/                # gitconfig and global ignore
├── hammerspoon/        # Hammerspoon init.lua
├── htop/               # htop
├── java/               # checkstyle and jdtls formatter settings
├── kitty/              # Kitty terminal and themes
├── lftp/               # lftp
├── mise/               # mise tool versions
├── neofetch/           # neofetch
├── opencode/           # opencode
├── scripts/            # Helper scripts, linked into ~/.local/bin
├── tldr/               # tldr (tlrc) client
├── tmux/               # tmux.conf
├── vim/                # vimrc
└── zsh/                # zshrc, zprofile, prompt, functions
```

## Install

> [!WARNING]
> These dotfiles are tailored to my own machine and workflow, so installing them as-is is discouraged. They may overwrite your existing configs. Treat this repo as a reference and borrow only what you need.

If you still want to install it despite the warning, go ahead.

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

## How linking works

- Most directories in `config/` follow the XDG convention and are linked into `~/.config/<name>` (`$XDG_CONFIG_HOME`).
- Tools that expect a file elsewhere (`~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`, `~/.vimrc`, `~/.aider.conf.yml`, etc.) are linked individually; see `.install.conf.yaml`.
- `config/zsh/*` (except `zshrc` and `zprofile`) is linked into `~/.zsh/`.

## License

This dotfiles repo is licensed under the [MIT License](LICENSE).
