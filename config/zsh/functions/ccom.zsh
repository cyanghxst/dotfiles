ccom() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: ccom file1.cpp [file2.cpp ...] [-o output_executable]"
        return 1
    fi

    OUTPUT="a.out"
    FILES=()

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -o)
                shift
                OUTPUT="$1"
                ;;
            *.cpp)
                FILES+=("$1")
                ;;
            *)
                echo "Unknown argument: $1"
                return 1
                ;;
        esac
        shift
    done

    if [ "${#FILES[@]}" -eq 0 ]; then
        echo "No source files provided. Please specify .cpp files."
        return 1
    fi

    if [ "${#FILES[@]}" -eq 1 ] && [ "$OUTPUT" == "a.out" ]; then
        OUTPUT="${FILES[0]%.cpp}"
    fi

    g++-14 -std=c++23 -O0 "${FILES[@]}" -o "$OUTPUT" -Wall -Werror -Wextra -Weffc++ -Wconversion -Wsign-conversion -pedantic-errors
    # g++-14 -std=c++17 -O2 "${FILES[@]}" -o "$OUTPUT" -Wall
}
