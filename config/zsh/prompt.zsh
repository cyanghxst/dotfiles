# -------------------
# Custom Zsh Prompt
# -------------------

# Based on Josh Dick’s Git Prompt
# Source: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

setopt prompt_subst
autoload -U colors && colors

typeset -g GIT_PROMPT_CACHE=()
typeset -g GIT_PROMPT_CACHE_TIME=0

git_info() {
    local now=$EPOCHSECONDS
    if (( now - GIT_PROMPT_CACHE_TIME < 60 && ${#GIT_PROMPT_CACHE} > 0 )); then
        print -r -- "$GIT_PROMPT_CACHE"
        return
    fi

    local GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
    [[ -z "$GIT_DIR" ]] && return

    local GIT_LOCATION BRANCH

    BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    GIT_LOCATION="${BRANCH:-$(git rev-parse --short HEAD 2>/dev/null)}"

    local -a DIVERGENCES

    local UPSTREAM="@{u}"
    local TRACKING="$(git rev-parse --abbrev-ref "$UPSTREAM" 2>/dev/null)"
    if [[ -n "$TRACKING" ]]; then
        local NUM_AHEAD=$(git rev-list --count "${UPSTREAM}..HEAD" 2>/dev/null)
        [[ -n "$NUM_AHEAD" && "$NUM_AHEAD" -gt 0 ]] && DIVERGENCES+=("%F{#456841}+${NUM_AHEAD}%{$reset_color%}")

        local NUM_BEHIND=$(git rev-list --count "HEAD..${UPSTREAM}" 2>/dev/null)
        [[ -n "$NUM_BEHIND" && "$NUM_BEHIND" -gt 0 ]] && DIVERGENCES+=("%F{#684141}-${NUM_BEHIND}%{$reset_color%}")
    fi

    local -a FLAGS
    local STATUS="$(git status --porcelain 2>/dev/null)"

    [[ "$STATUS" == *\?* ]] && FLAGS+=("%F{#684141}%{$reset_color%}")
    [[ "$STATUS" == *[M]* ]] && FLAGS+=("%F{#676841}%{$reset_color%}")
    [[ "$STATUS" == *[AC]* ]] && FLAGS+=("%F{#456841}%{$reset_color%}")
    [[ -n $GIT_DIR && -r $GIT_DIR/MERGE_HEAD ]] && FLAGS+=("%F{#614168}󱐌%{$reset_color%}")

    local -a GIT_INFO
    GIT_INFO+=( "%F{#414868}on%{$reset_color%}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%F{#414868}$GIT_LOCATION%{$reset_color%}" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )

    GIT_PROMPT_CACHE="${(j: :)GIT_INFO}"
    GIT_PROMPT_CACHE_TIME=$now
    print -r -- "$GIT_PROMPT_CACHE"
}

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{#414868}($(basename $VIRTUAL_ENV))%{$reset_color%} "
    fi
}

ssh_info() {
    if [[ -n "$SSH_CONNECTION" ]]; then
        local ssh_client="${SSH_CLIENT%% *}"
        local ssh_client_short="${ssh_client%.*}"
        echo "%F{#414868}via ${ssh_client_short}%{$reset_color%} "
    fi
}

PS1='$(venv_info)$(ssh_info)%F{#414868}%~%u $(git_info)
%(?.%F{#c0caf5}.%F{#f7768e})%(!.#.󱐋)%{$reset_color%} '
