#!/usr/bin/env bash
# Install eza if missing, then alias ls/la/ll to it in zsh and bash.
# Safe to re-run: the alias block is replaced in place, never duplicated.
set -euo pipefail

BEGIN="# >>> eza-setup >>>"
END="# <<< eza-setup <<<"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# Run a command as root if we aren't already.
as_root() { if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi; }

install_eza() {
  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null || die "Homebrew not found. Install it from https://brew.sh then re-run."
      brew install eza
      ;;
    Linux)
      if command -v apt-get >/dev/null; then
        # Official instructions: https://github.com/eza-community/eza/blob/main/INSTALL.md
        as_root apt-get update
        as_root apt-get install -y gpg wget ca-certificates
        as_root mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
          | as_root gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
          | as_root tee /etc/apt/sources.list.d/gierens.list >/dev/null
        as_root chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        as_root apt-get update
        as_root apt-get install -y eza
      elif command -v dnf >/dev/null;    then as_root dnf install -y eza
      elif command -v pacman >/dev/null; then as_root pacman -S --noconfirm eza
      elif command -v zypper >/dev/null; then as_root zypper --non-interactive install eza
      elif command -v cargo >/dev/null;  then cargo install eza
      else die "No supported package manager found. See https://github.com/eza-community/eza/blob/main/INSTALL.md"
      fi
      ;;
    *) die "Unsupported OS: $(uname -s)" ;;
  esac
}

# Replace (or append) the managed alias block in an rc file.
write_block() {
  local rc="$1" tmp
  [ -f "$rc" ] || touch "$rc"
  tmp="$(mktemp)"
  # Drop any previous block, then append the current one.
  awk -v b="$BEGIN" -v e="$END" '
    $0 == b {skip=1; next}
    $0 == e {skip=0; next}
    !skip
  ' "$rc" > "$tmp"
  cat >> "$tmp" <<BLOCK
$BEGIN
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias la='eza -la --group-directories-first'
  alias ll='eza -l --group-directories-first'
fi
$END
BLOCK
  cat "$tmp" > "$rc"   # preserve rc file permissions/symlinks
  rm -f "$tmp"
  log "updated $rc"
}

if command -v eza >/dev/null 2>&1; then
  log "eza already installed: $(command -v eza)"
else
  log "installing eza"
  install_eza
  command -v eza >/dev/null 2>&1 || die "eza still not on PATH after install (open a new shell or check ~/.cargo/bin)"
fi

write_block "$HOME/.zshrc"
write_block "$HOME/.bashrc"

log "done. Open a new shell (or: source ~/.zshrc) to use ls/la/ll via eza."
