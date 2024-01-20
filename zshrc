# ---------------------------------------- 
# zshrc Config
# ---------------------------------------- 

# ---------------------------------------- 
# General
# ---------------------------------------- 

# Emacs key bindings
bindkey -e

# # Share history between tmux windows
# setopt inc_append_history
# setopt share_history

# ---------------------------------------- 
# Source
# ---------------------------------------- 

# Source zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Source zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---------------------------------------- 
# Environment Variables
# ---------------------------------------- 

# Default editor
export EDITOR='nvim'

# Default
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/local/bin:/opt/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/xenon/.cargo/bin

# Locale
export LANG=en_US.UTF-8

# Fzf color options
export FZF_DEFAULT_OPTS='
--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1
--color=fg:#c0caf5,fg+:#16161e
--color=bg:-1,bg+:#9ece6a
--color=hl:#fa2d90,hl+:#16161e
--color=gutter:#414868
--color=scrollbar:#16161e
--color=info:#9ece6a,pointer:#16161e
--color=border:#414868,spinner:#E6DB74,header:#7E8E91,marker:#F92672,prompt:#9ece6a'
# --color=hl:#fa2d90,hl+:#1434F5

# Default grep color
export GREP_OPTIONS='--color=always'
export GREP_COLOR='0;94' # dull blue

# ---------------------------------------- 
# Aliases
# ---------------------------------------- 

# List by long-list, color, modified time and human-readable file size
alias ls='ls -Glth'

# List only dotfiles by long-list, color, modified time and human-readable file size
alias lsd='ls -Gldth .*'

# Fortune with cowsay
alias fortune='fortune | cowsay'

# Source .zshrc and clear
alias zsh='source ~/.zshrc && clear'

# Go to home directory and clear
alias cdc='cd && clear'

# Go to downloads directory and list
alias cdd='cd ~/Downloads && ls'

# Remove an empty line when use command clear
alias clear='unset NEW_LINE_BEFORE_PROMPT && clear'

# Remove an empty line when use command reset
alias reset='unset NEW_LINE_BEFORE_PROMPT && reset'

# Fortune with cowsay speak
alias forsay='\fortune > a.txt | cowsay && say -f a.txt && rm a.txt'

# neofetch in rainbow color
alias neofetch='neofetch | lolcat -a -t -d 3 -s 60 -S 9'

# pipe.sh in rainbow color
alias pipes.sh='pipes.sh | lolcat'

# pipe fzf output to nvim
alias nf='fzf --print0 | xargs -0 -o nvim'

# open with fzf
alias of='fzf --print0 | xargs -0 -o open'

# ---------------------------------------- 
# Tab Completion Settings 
# ---------------------------------------- 

# Case-insensitive for completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# ---------------------------------------- 
# Prompt Settings
# ---------------------------------------- 

# Print a new line before the prompt, unless it's the first prompt in the process
function precmd() {
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}

# ---------------------------------------- 
# Manual Page Settings
# ---------------------------------------- 

# Start blinking
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green

# Start bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 2) # green

# Start standout
export LESS_TERMCAP_so=$(tput bold; tput rev; tput setaf 3) # yellow

# End stand out
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)

# Start underline
export LESS_TERMCAP_us=$(tput smul; tput setaf 4) # blue

# End bold, blinking, standout, underline
export LESS_TERMCAP_me=$(tput sgr0)


# ---------------------------------------- 
# Josh Dick's zsh prompt
# ---------------------------------------- 

# Enable colors in prompt
setopt prompt_subst
autoload -U colors && colors

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
    [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%F{#684141}NUM%{$reset_color%}"
  local BEHIND="%F{#416068}NUM%{$reset_color%}"
  local MERGING="%F{#614168}%{$reset_color%}"
  local UNTRACKED="%F{#684141}●%{$reset_color%}"
  local MODIFIED="%F{#676841}●%{$reset_color%}"
  local STAGED="%F{#456841}●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
      DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
      DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
      FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
      FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
      FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
      FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "%F{#414868}±" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "%F{#414868}$GIT_LOCATION%{$reset_color%}" )
  echo "${(j: :)GIT_INFO}"

}

# Use 󱐋 as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1='$(ssh_info)%F{#414868}%~%u $(git_info)
%(?.%F{#c0caf5}.%F{red})%(!.#.󱐋)%{$reset_color%} '
