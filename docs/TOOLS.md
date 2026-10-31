# Tools

What each tool is, what it replaces, and a few commands to try. One-line descriptions and homepages come from `brew info` (checked 2026-10-31). Examples marked ✓ were run on macOS and produced the output shown; unmarked ones are interactive and were not run.

| tool | command | what it is | replaces / pairs with | homepage |
|---|---|---|---|---|
| eza | `eza` | modern `ls` | replaces `ls`, `tree` | https://eza.rocks |
| bat | `bat` | `cat` with syntax highlighting and Git integration | replaces `cat` | https://github.com/sharkdp/bat |
| ripgrep | `rg` | fast recursive text search, like grep | use instead of `grep -r` (not aliased) | https://github.com/BurntSushi/ripgrep |
| fd | `fd` | simple, fast alternative to `find` | use instead of `find` (not aliased) | https://github.com/sharkdp/fd |
| fzf | `fzf` | command-line fuzzy finder | pipe any list into it | https://junegunn.github.io/fzf/ |
| zoxide | `z`, `cd` | jump to directories you've visited | replaces `cd` | https://github.com/ajeetdsouza/zoxide |
| btop | `btop` | resource monitor (CPU, memory, disks, network, processes) | replaces `top` | https://github.com/aristocratos/btop |
| jq | `jq` | command-line JSON processor | no default to replace | https://jqlang.github.io/jq/ |

## fd: find files by name
`fd` takes a pattern, not `-name`. It skips hidden files and anything in `.gitignore` by default.
```sh
fd txt            # files whose name matches "txt"        ✓ prints src/a.txt
fd -e json        # files with the .json extension        ✓ prints data.json
```

## fzf: pick from a list
Reads lines from stdin, lets you narrow them by typing fuzzy fragments, and prints your choice.
```sh
printf 'apple\nbanana\ncherry\n' | fzf --filter=bna   # ✓ prints banana (non-interactive match)
fd -e md | fzf                                          # interactively pick a markdown file
```
This repo installs fzf but does not enable its shell key bindings (e.g. Ctrl-R history search). Add them yourself if you want them.

## zoxide: smarter cd
It learns which directories you visit and ranks them. `terminal-setup` wires it as `cd`, so plain `cd path` and `cd -` still work.
```sh
cd ~/Code/terminal-setup   # visit once so zoxide learns it
cd terminal                # later: jumps to the best match for "terminal"
cdi                        # interactive picker (uses fzf)
zoxide query src           # ✓ prints the matching path without moving (TMP/src in my test)
```
It only knows directories you've already been in. A fresh machine starts empty.

## jq: read and reshape JSON
Given `{"name":"x","tags":["a","b"],"n":3}`:
```sh
jq -r .name data.json        # ✓ x
jq -c '.tags' data.json      # ✓ ["a","b"]
jq '.n + 1' data.json        # ✓ 4
curl -s https://api.github.com/repos/junegunn/fzf | jq '.stargazers_count'
```

## ripgrep (rg): search file contents
```sh
rg TODO           # ✓ prints src/a.txt:hello TODO (recursive, respects .gitignore)
rg -t py 'def '   # only Python files
```
Not aliased over `grep` because flags differ (`rg -E` is an encoding, not extended regex).

## bat, eza, btop
```sh
bat file.py            # syntax-highlighted, with line numbers and Git markers
cat file               # alias: bat --paging=never --style=plain (✓ prints file contents)
eza --tree             # ✓ tree view (also what `tree` runs)
btop                   # interactive monitor; q to quit (✓ version 1.4.7 here)
```

## Using the real command
Aliases apply only in interactive shells. To bypass one: `\cat file` or `command cat file`.
