#!/usr/bin/env bash
#
# flatten-dir — move every nested file up to a root directory, then remove
# the now-empty subdirectories.
#
#   root/dir1/file1  root/dir2/file2  root/dir3/dir4/file3
#     ->  root/file1  root/file2  root/file3
#
# Usage:
#   flatten-dir [-n] [DIR]
#
#   DIR   directory to flatten (default: current directory)
#   -n    dry run — print what would happen without changing anything

set -euo pipefail

dry_run=0
while getopts "nh" opt; do
  case "$opt" in
    n) dry_run=1 ;;
    h) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "usage: flatten-dir [-n] [DIR]" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

root="${1:-.}"

if [[ ! -d "$root" ]]; then
  echo "flatten-dir: '$root' is not a directory" >&2
  exit 1
fi

run() {
  if (( dry_run )); then
    printf 'would: %s\n' "$*"
  else
    "$@"
  fi
}

# Move every file that lives below the root (depth >= 2) into the root.
# -mindepth 2 skips files already at the root level.
while IFS= read -r -d '' file; do
  base="$(basename "$file")"
  dest="$root/$base"

  # Resolve collisions by appending a counter before the extension.
  if [[ -e "$dest" ]]; then
    name="${base%.*}"
    ext="${base##*.}"
    [[ "$name" == "$base" ]] && ext=""   # no extension
    n=1
    while :; do
      if [[ -n "$ext" ]]; then
        dest="$root/${name}_$n.$ext"
      else
        dest="$root/${name}_$n"
      fi
      [[ -e "$dest" ]] || break
      ((n++))
    done
  fi

  run mv -n -- "$file" "$dest"
done < <(find "$root" -mindepth 2 -type f -print0)

# Remove the directories left behind. -depth visits children before parents,
# so a dir emptied by removing its subdirs still gets cleaned up. Emptiness is
# re-checked here (not at scan time) for the same reason.
while IFS= read -r -d '' dir; do
  if [[ -z "$(ls -A -- "$dir")" ]]; then
    run rmdir -- "$dir"
  fi
done < <(find "$root" -mindepth 1 -depth -type d -print0)
