exercism () {
    local out=("${(@f)$(command exercism "$@")}")

    printf '%s\n' "${out[@]}"

    if [[ $1 == "download" && -d "${out[-1]}" ]]; then
        cd "${out[-1]}" || return 1
    fi
}
