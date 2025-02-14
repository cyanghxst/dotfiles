gozip() {
    file="$1"

    if [ -z "$file" ]; then
        echo "gozip: enter the name"
        return 1
    elif [ -d "$file" ]; then
        zip -r "$file.zip" "$file" && trash "$file"
        return 0
    else
        zip "$file.zip" "$file" && trash "$file" || return 1
    fi
}
