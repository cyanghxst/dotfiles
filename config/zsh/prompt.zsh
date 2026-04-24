# -------------------
# Custom Zsh Prompt
# -------------------

# Based on Josh Dick’s Git Prompt
# Source: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

setopt prompt_subst
autoload -U colors && colors

ssh_info() {
    [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

git_info() {
    local GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
    [[ -z "$GIT_DIR" ]] && return

    local GIT_LOCATION BRANCH

    BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    GIT_LOCATION="${BRANCH:-$(git rev-parse --short HEAD 2>/dev/null)}"

    local -a FLAGS

    [[ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]] && FLAGS+=("%F{#684141}%{$reset_color%}")
    ! git diff --quiet 2>/dev/null && FLAGS+=("%F{#676841}%{$reset_color%}")
    ! git diff --cached --quiet 2>/dev/null && FLAGS+=("%F{#456841}%{$reset_color%}")
    [[ -n $GIT_DIR && -r $GIT_DIR/MERGE_HEAD ]] && FLAGS+=("%F{#614168}󱐌%{$reset_color%}")

    local -a GIT_INFO
    GIT_INFO+=( "%F{#414868}on%{$reset_color%}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%F{#414868}$GIT_LOCATION%{$reset_color%}" )
    echo "${(j: :)GIT_INFO}"
}

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{#414868}($(basename $VIRTUAL_ENV))%{$reset_color%} "
    fi
}

PS1='$(venv_info)$(ssh_info)%F{#414868}%~%u $(git_info)
%(?.%F{#c0caf5}.%F{#f7768e})%(!.#.󱐋)%{$reset_color%} '
