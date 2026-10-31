# terminal-setup

Portable terminal setup. Safe on a work machine: it only **appends** to your shell rc files and never rewrites or deletes existing content.

```sh
# one-liner (clones to ~/Code/terminal-setup, then runs install.sh)
curl -fsSL https://raw.githubusercontent.com/joshjones-codes/terminal-setup/main/bootstrap.sh | bash

# preview first, changing nothing
curl -fsSL https://raw.githubusercontent.com/joshjones-codes/terminal-setup/main/bootstrap.sh | bash -s -- --dry-run
```

Tool descriptions and examples: [docs/TOOLS.md](docs/TOOLS.md).

Or clone it yourself and run `./install.sh [--dry-run] [--no-install]`.

| flag | effect |
|---|---|
| `--dry-run` | print what would happen, change nothing |
| `--no-install` | skip package installs (no sudo, no third-party apt repo); only wire up aliases |

Set `TERMINAL_SETUP_DIR` to clone somewhere other than `~/Code/terminal-setup`.

## Tools installed (`packages/tools.txt`)
eza, bat, ripgrep, fd, fzf, zoxide, btop, jq. macOS uses brew; Linux uses apt, dnf, pacman, zypper or cargo. On Debian/Ubuntu, eza comes from the eza project's apt repo, which adds a third-party source (skip with `--no-install`).

## Defaults replaced (interactive shells only)
| command | becomes |
|---|---|
| `ls`, `la`, `ll` | `eza` (dirs first; `la` = `-la`, `ll` = `-l`) |
| `tree` | `eza --tree` |
| `cat` | `bat --paging=never --style=plain` |
| `top` | `btop` |
| `cd` | zoxide (learns directories; `cd path` and `cd -` still work) |

Scripts are unaffected: the aliases load only in interactive shells. Bypass once with `\cat file` or `command cat file`.

**Not replaced:** `grep` and `find`. `rg` and `fd` have different flags (`rg -E` is an encoding, `fd` has no `-name`), so aliasing them breaks muscle memory. Opt-in lines are commented at the bottom of `shell/aliases.sh`.

## What gets appended
One block to `~/.zshrc` and/or `~/.bashrc` (only files that already exist; if neither exists, creates the one matching `$SHELL`). Re-running does nothing if the block is present.
```sh
# >>> terminal-setup (joshjones-codes/terminal-setup) >>>
[ -f "<clone>/shell/aliases.sh" ] && . "<clone>/shell/aliases.sh"
# <<< terminal-setup <<<
```

## Layout
`bootstrap.sh` (clone + run) · `install.sh` (install tools, append source line) · `shell/aliases.sh` · `packages/tools.txt` · `docs/TOOLS.md`

## Remove
Delete the three-line block from your rc file. Nothing else was changed.
