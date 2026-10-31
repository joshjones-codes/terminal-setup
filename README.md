# dotfiles

Portable terminal setup. Safe to run on a work machine: it only ever **appends** to your shell rc files and never rewrites or deletes existing content.

```sh
git clone https://github.com/joshjones-codes/dotfiles.git ~/Code/dotfiles
~/Code/dotfiles/install.sh
```

| flag | effect |
|---|---|
| `--dry-run` | print what would happen, change nothing |
| `--no-install` | skip package installs (no sudo, no third-party repos); only wire up aliases |

## What it does
1. Installs each tool in `packages/tools.txt` if it's missing (macOS: brew; Linux: apt/dnf/pacman/zypper/cargo). On Debian/Ubuntu, eza comes from the eza project's apt repo, which adds a third-party source. Use `--no-install` to avoid that.
2. Appends one block to `~/.zshrc` and/or `~/.bashrc` (only files that already exist; if neither exists, creates the one matching `$SHELL`):
   ```sh
   # >>> dotfiles (joshjones-codes/dotfiles) >>>
   [ -f "<clone>/shell/aliases.sh" ] && . "<clone>/shell/aliases.sh"
   # <<< dotfiles <<<
   ```
3. Re-running does nothing if that block is already present.

## Layout
- `shell/aliases.sh`: portable aliases (`ls`, `la`, `ll` via eza, only if eza is installed)
- `packages/tools.txt`: tools to install, one per line
- `install.sh`: bootstrap

## Remove
Delete the three-line block from your rc file. Nothing else was changed.

Note: the aliases shadow `ls` in new shells, so they override any existing `ls` alias that's defined earlier in the same rc file.
