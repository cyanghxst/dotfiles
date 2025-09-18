nf() {
    local file dir base

    file="$(fzf --exit-0)" || return 0
    [[ -n "$file" ]] || return 1

    dir="${file%/*}"
    base="${file##*/}"

    [[ "$dir" == "$base" ]] && dir="."

    nvim -- "$base"
}
