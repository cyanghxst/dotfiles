ccom() {
    local output=""
    local srcs=()
    local objs=()
    local has_cpp=0

    while (( $# )); do
        case "$1" in
            -o)
                output="$2"
                shift 2
                ;;
            *)
                srcs+=("$1")
                shift
                ;;
        esac
    done

    (( ${#srcs} == 0 )) && {
        echo "ccom: no input files"
        return 1
    }

    # zsh arrays are 1-based
    if [[ -z $output ]]; then
        output="${srcs[1]%.*}"
    fi
    [[ -z $output ]] && output="a.out"

    for src in "${srcs[@]}"; do
        obj="${src%.*}.o"
        case "$src" in
            *.c)
                clang -std=c17 -O0 -c "$src" -o "$obj" \
                    -Wall -Wextra -Werror -Wconversion -Wsign-conversion -pedantic-errors || return 1
                ;;
            *.cpp|*.cc|*.cxx)
                has_cpp=1
                clang++ -std=c++20 -O0 -c "$src" -o "$obj" \
                    -Wall -Wextra -Werror -Wconversion -Wsign-conversion \
                    -Weffc++ -pedantic-errors || return 1
                ;;
            *)
                echo "ccom: unsupported file type: $src"
                return 1
                ;;
        esac
        objs+=("$obj")
    done

    if (( has_cpp )); then
        clang++ "${objs[@]}" -o "$output"
    else
        clang "${objs[@]}" -o "$output"
    fi
}
