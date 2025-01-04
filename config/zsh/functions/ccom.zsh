ccom() {
    local output=""
    local files=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -o)
                output="$2"
                shift 2
                ;;
            *)
                files+=("$1")
                shift
                ;;
        esac
    done

    if [[ -z "$output" ]]; then
        output="${files[1]%.*}"  # Use the name of the first file as default
    fi

    g++ -std=c++23 -O0 "${files[@]}" -o "$output" -Wall -Werror -Wextra -Weffc++ -Wconversion -Wsign-conversion -pedantic-errors
    # g++ -std=c++17 -O2 -o "${files[@]}" "$output" -Wall }
}
