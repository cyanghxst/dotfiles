nf() {
    local file

    file="$(find . -not -path '*/.*' -type f -not -name '*.class' | fzf --exit-0)" || return 0
    [[ -n "$file" ]] || return 1

    nvim -- "$file"
}
