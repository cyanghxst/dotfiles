# Set up UV to use a venv directory in ~/.cache/uv-venv, based on the project
# root directory or the current working directory if no project can be found.
#
# Courtesy Hawk777: https://github.com/astral-sh/uv/issues/1495#issuecomment-2910199607
uv() {
    local uv_project_root=$(/usr/bin/uv -v python find 2>&1 >/dev/null | sed -ne '/Found project root: `/{s/^.*Found project root: `\(.*\)`$/\1/;p}')
    if [[ -n $uv_project_root ]]; then
        export UV_PROJECT_ENVIRONMENT=~/.cache/uv-venv/$uv_project_root
    else
        export UV_PROJECT_ENVIRONMENT=~/.cache/uv-venv/$PWD
    fi
    command uv "$@"
}
