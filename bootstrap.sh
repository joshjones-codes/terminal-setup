#!/usr/bin/env bash
# One-liner entry point: clones (or fast-forwards) the repo, then runs install.sh.
#   curl -fsSL https://raw.githubusercontent.com/joshjones-codes/terminal-setup/main/bootstrap.sh | bash
#   ... | bash -s -- --dry-run        (flags pass through to install.sh)
# Clone location: $TERMINAL_SETUP_DIR (default ~/Code/terminal-setup).
set -euo pipefail

REPO="https://github.com/joshjones-codes/terminal-setup.git"
DIR="${TERMINAL_SETUP_DIR:-$HOME/Code/terminal-setup}"

command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only
else
  [ -e "$DIR" ] && { echo "error: $DIR exists and is not a git clone" >&2; exit 1; }
  git clone "$REPO" "$DIR"
fi

exec "$DIR/install.sh" "$@"
