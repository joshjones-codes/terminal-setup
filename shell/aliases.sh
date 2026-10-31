# Portable aliases that replace default commands with modern ones.
# Interactive shells only (scripts keep the real ls/cat/cd). Every block is
# guarded, so a missing tool just means the default command stays.
# To bypass an alias once: \cat file   or   command cat file

case $- in *i*) ;; *) return 0 2>/dev/null || true ;; esac

# Debian/Ubuntu ship these under different binary names.
command -v bat >/dev/null 2>&1 || { command -v batcat >/dev/null 2>&1 && alias bat='batcat'; }
command -v fd  >/dev/null 2>&1 || { command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'; }

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias la='eza -la --group-directories-first'
  alias ll='eza -l --group-directories-first'
  alias tree='eza --tree'
fi

if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
fi

command -v btop >/dev/null 2>&1 && alias top='btop'

# cd -> zoxide (learns your directories; plain `cd path` and `cd -` still work)
if command -v zoxide >/dev/null 2>&1; then
  if   [ -n "${ZSH_VERSION:-}" ];  then eval "$(zoxide init zsh --cmd cd)"
  elif [ -n "${BASH_VERSION:-}" ]; then eval "$(zoxide init bash --cmd cd)"
  fi
fi

# Not replaced by default because the flags differ from the originals
# (e.g. rg -E is an encoding, fd has no -name). Uncomment to opt in:
# command -v rg >/dev/null 2>&1 && alias grep='rg'
# command -v fd >/dev/null 2>&1 && alias find='fd'
