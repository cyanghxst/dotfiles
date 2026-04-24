up() {
    cd "$(printf '../%.0s' $(seq 1 ${1:-1}))"
}
