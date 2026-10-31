#!/usr/bin/env bash
# Append-only bootstrap: installs missing tools, then appends ONE source line
# to your shell rc file(s). Never rewrites or removes existing content.
#   ./install.sh                run everything
#   ./install.sh --no-install   only wire up the aliases (no packages, no sudo)
#   ./install.sh --dry-run      print what would happen, change nothing
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIASES="$DOTFILES_DIR/shell/aliases.sh"
BEGIN="# >>> terminal-setup (joshjones-codes/terminal-setup) >>>"
END="# <<< terminal-setup <<<"
INSTALL=1
DRY=0

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }
as_root() { if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi; }

for arg in "$@"; do
  case "$arg" in
    --no-install) INSTALL=0 ;;
    --dry-run)    DRY=1 ;;
    -h|--help)    sed -n '2,6p' "$0"; exit 0 ;;
    *) die "unknown option: $arg" ;;
  esac
done

install_tool() {
  local tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then log "$tool already installed"; return; fi
  if [ "$DRY" -eq 1 ]; then log "[dry-run] would install $tool"; return; fi
  log "installing $tool"
  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null || die "Homebrew not found (https://brew.sh)"
      brew install "$tool" ;;
    Linux)
      if command -v apt-get >/dev/null; then
        if [ "$tool" = eza ]; then
          # https://github.com/eza-community/eza/blob/main/INSTALL.md
          as_root apt-get update
          as_root apt-get install -y gpg wget ca-certificates
          as_root mkdir -p /etc/apt/keyrings
          wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
            | as_root gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
          echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
            | as_root tee /etc/apt/sources.list.d/gierens.list >/dev/null
          as_root chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        fi
        as_root apt-get update
        as_root apt-get install -y "$tool"
      elif command -v dnf >/dev/null;    then as_root dnf install -y "$tool"
      elif command -v pacman >/dev/null; then as_root pacman -S --noconfirm "$tool"
      elif command -v zypper >/dev/null; then as_root zypper --non-interactive install "$tool"
      elif command -v cargo >/dev/null;  then cargo install "$tool"
      else die "no supported package manager for $tool"
      fi ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

# Append only. If our marker is already present, do nothing at all.
append_source() {
  local rc="$1"
  if grep -qF "$BEGIN" "$rc" 2>/dev/null; then log "$rc already configured, left untouched"; return; fi
  if [ "$DRY" -eq 1 ]; then log "[dry-run] would append source line to $rc"; return; fi
  printf '\n%s\n[ -f "%s" ] && . "%s"\n%s\n' "$BEGIN" "$ALIASES" "$ALIASES" "$END" >> "$rc"
  log "appended to $rc"
}

if [ "$INSTALL" -eq 1 ]; then
  while IFS= read -r tool; do
    case "$tool" in ''|'#'*) continue ;; esac
    install_tool "$tool"
  done < "$DOTFILES_DIR/packages/tools.txt"
fi

targets=()
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do [ -f "$rc" ] && targets+=("$rc"); done
if [ "${#targets[@]}" -eq 0 ]; then
  case "${SHELL:-}" in */zsh) targets=("$HOME/.zshrc") ;; *) targets=("$HOME/.bashrc") ;; esac
fi
for rc in "${targets[@]}"; do append_source "$rc"; done

log "done. Open a new shell to pick up the aliases."
