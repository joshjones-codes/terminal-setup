# Portable aliases. Sourced from your rc file; safe when a tool is missing.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias la='eza -la --group-directories-first'
  alias ll='eza -l --group-directories-first'
fi
