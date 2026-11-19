# Custom keybindings

Keyboard behaviour that spans several configs in this repo. See the main [README](../README.md) for the repo layout and install steps.

## Caps lock

Karabiner-Elements remaps caps lock depending on how it is pressed:

| Action | Behavior |
| --- | --- |
| Hold | Control |
| Tap and quick release | Escape |

> [!NOTE]
> Caps lock sits on the home row, one of the easiest keys to reach, yet it is rarely needed since Shift already handles capitals. Inspired by [this](https://dannyguo.medium.com/remap-caps-lock-to-escape-and-control-774576c135e6) article, I put it to work as the two keys I use most: Control for shortcuts and Escape for Vim.

## Selecting a command's output

Select the output of a previous command without touching the mouse, then yank it with `y`. The keys are the same in tmux and Rex:

| Key | Action |
| --- | --- |
| `Ctrl+Shift+k` | Select the last command's output; press again to walk to older output |
| `Ctrl+Shift+j` | Walk back to newer output, leaving copy mode past the newest |

Prompts are found by their text:

- The zsh prompt from `config/zsh/prompt.zsh`
- The default `user@host:path$` prompt on remote hosts.

Inside Rex, the keys go to tmux when it is running.

> [!IMPORTANT]
> If a prompt changes, update the patterns in both places: `LOCAL_PROMPT` and `REMOTE_PROMPT` in `config/rex/init.lua`, and `PROMPT_SEARCH`, `PROMPT_LINE` and `LOCAL_LINE` in `config/tmux/tmux.conf`.
