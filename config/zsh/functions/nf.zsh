nf() {
    local file

    file="$(fzf --exit-0)" || return 0
    [[ -n "$file" ]] || return 1

    nvim -- "$file"
}
