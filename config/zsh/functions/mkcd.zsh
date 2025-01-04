mkcd() {
    if [ -z "$1" ]; then
        echo "mkcd: enter a directory name"
        return 1
    elif [ -d "$1" ]; then
        echo "mkcd: '$1' already exists"
        cd "$1" || return 1
    else
        mkdir -p "$1" && cd "$1" || return 1
    fi
}
