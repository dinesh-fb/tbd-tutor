#!/usr/bin/env bash
# Install the TBD Tutor skill by symlinking this checkout into agent skill dirs.
# Usage: ./install.sh [target-dir ...]
#   ./install.sh                      # auto-detect: ~/.claude/skills and ~/.agents/skills
#   ./install.sh ~/.pi/agent/skills   # explicit target(s)

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="tbd-tutor"

if [ "$#" -gt 0 ]; then
  TARGETS=("$@")
else
  TARGETS=()
  for d in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
    [ -d "$(dirname "$d")" ] && TARGETS+=("$d")
  done
  if [ "${#TARGETS[@]}" -eq 0 ]; then
    echo "No skill directory found. Pass one explicitly, e.g.:"
    echo "  ./install.sh \"\$HOME/.pi/agent/skills\""
    exit 1
  fi
fi

for dir in "${TARGETS[@]}"; do
  mkdir -p "$dir"
  dest="$dir/$NAME"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip: $dest exists and is not a symlink (remove it yourself if you want the symlink)"
    continue
  fi

  ln -sfn "$SRC" "$dest"
  echo "linked: $dest -> $SRC"
done

echo
echo "Done. Start with:  quiz me on trunk-based development"
