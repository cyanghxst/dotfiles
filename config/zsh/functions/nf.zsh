nf() {
    local file dir base

    file="$(fzf --exit-0)" || return
    [[ -n "$file" ]] || return

    dir="${file%/*}"
    base="${file##*/}"

    [[ "$dir" == "$base" ]] && dir="."

    cd -- "$dir" || return
    nvim -- "$base"
}
