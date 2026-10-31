# eza-setup

Installs [eza](https://github.com/eza-community/eza) if it's missing and aliases `ls`, `la`, `ll` to it in zsh and bash.

```sh
curl -fsSL https://raw.githubusercontent.com/<user>/eza-setup/main/install.sh | bash
```

Or clone and run `./install.sh`.

- macOS: `brew install eza`
- Linux: apt (via the eza project's deb repo), dnf, pacman, zypper, or cargo, per [eza's INSTALL.md](https://github.com/eza-community/eza/blob/main/INSTALL.md)
- Aliases live in a marked block in `~/.zshrc` and `~/.bashrc`; re-running replaces the block, never duplicates it.

| alias | expands to |
|---|---|
| `ls` | `eza --group-directories-first` |
| `la` | `eza -la --group-directories-first` |
| `ll` | `eza -l --group-directories-first` |

To remove: delete the block between `# >>> eza-setup >>>` and `# <<< eza-setup <<<`.
