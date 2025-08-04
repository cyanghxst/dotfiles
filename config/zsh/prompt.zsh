# ----------------------------------------
# Custom Zsh Prompt
# Based on Josh Dick’s Git Prompt
# Source: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html
# ----------------------------------------

setopt prompt_subst
autoload -U colors && colors

ssh_info() {
    [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

git_info() {
    ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

    local AHEAD="%F{#456841}+NUM%{$reset_color%}"
    local BEHIND="%F{#684141}-NUM%{$reset_color%}"
    local MERGING="%F{#614168}󱐌%{$reset_color%}"
    local UNTRACKED="%F{#684141}%{$reset_color%}"
    local MODIFIED="%F{#676841}%{$reset_color%}"
    local STAGED="%F{#456841}%{$reset_color%}"

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
    GIT_INFO+=( "%F{#414868}on%{$reset_color%}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%F{#414868}$GIT_LOCATION%{$reset_color%}" )
    [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
    echo "${(j: :)GIT_INFO}"
}

PS1='$(ssh_info)%F{#414868}%~%u $(git_info)
%(?.%F{#c0caf5}.%F{#f7768e})%(!.#.󱐋)%{$reset_color%} '
