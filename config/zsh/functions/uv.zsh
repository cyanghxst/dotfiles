# Custom uv wrapper to use a centralized venv location under ~/.cache/uv-venv
#
# Modified from Hawk777's idea:
# https://github.com/astral-sh/uv/issues/1495#issuecomment-2910199607

uv() {
    local uv_project_root hash

    uv_project_root=$(
        /usr/bin/uv -v python find 2>&1 >/dev/null | \
            sed -n -e '/Found project root: `/ {
                s/^.*Found project root: `\(.*\)`$/\1/
                p
            }'
    )

    if [[ -n "$uv_project_root" ]]; then
        hash=$(echo "$uv_project_root" | sha256sum | cut -c1-8) # use hashing for unique id
    else
        hash=$(echo "$PWD" | sha256sum | cut -c1-8)
    fi

    export UV_PROJECT_ENVIRONMENT="$HOME/.cache/uv-venv/$hash"

    command uv "$@"
}
