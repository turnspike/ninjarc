# Ninjarc
Super minimal .rc files for traipsing around Other People's Servers™

# Why?

Get In And Get Out of some random server with color and comfort. Zero dependencies to install. No plugins. The only external tool used is [fuzzy-finder](https://github.com/junegunn/fzf/), which is portable.

This is an experiment in minimalism as a response to my previous [plugin-heavy, super customized workflow](https://github.com/turnspike/aetherwolf). Using every plugin under the sun was like unto a tacticool mallninja. Another goal is to minimise friction when using Vim mode in various IDEs such as [Spacemacs](http://spacemacs.org) and [Atom](https://atom.io), which don't necessarily have particular Vim plugins available. 

# Philosophy

**Yes:**
- Speed
- Simplicity
- Small problem space, easy to hold in mind

**Minimal:**
- Shortcuts to remember
- Helper functions

**No:**
- Dependencies to install
- Plugins
- Leader keys

# Installation
```sh
git clone https://github.com/turnspike/ninjarc.git ~/ninjarc && chmod u+x ~/ninjarc/install.sh && ~/ninjarc/install.sh
```

Ninjarc will skip existing files by default. To force overwrite, run install.sh with the -f param:
```sh
~/ninjarc/install.sh -f
```

---

# User Settings

You might want to add your own user settings eg git username. Just:
```sh
cp -f ~/ninjarc/*.user ~
```

Then edit to taste. This step can usually be ignored for ops work on random servers.

---
# Bash notes

List aliases:
```sh
alias
```

List non-OS functions:
```sh
list-funcs
```

---
# Vim notes

No plugins, mimimal config.

## Living without plugins

The [Tim Pope](https://github.com/tpope) plugins are pretty hard to give up. I may cave on this in the future.

### Commenting
Living without [vim-commentary](https://github.com/tpope/vim-commentary):

| | |
|-|-|
| **Comment a single line** | `I// <Esc>` |
| **Uncomment a single line** | `^dw` |
| **Comment several lines** | `<c-v>jjj` <br> `I//<esc>` |
| **Uncomment several lines** | `<c-v>jjj` <br> `2x<esc>` |

### Quoting
Living without [vim-surround](https://github.com/tpope/vim-surround):

| | |
|-|-|
| **Quote a word** | `ciw'Ctrl+r"` <br> *or* <br> `ciw '' Esc P` |
| **Unquote a word** | `di'hPl2x` |
| **Change single quotes to double quotes** | `va':s/\%V'\%V/"/g` |
| **Quote all words in a line** | `:s/\v(\S+)/"\1"/` |

### Files
Living without [fzf.vim](https://github.com/junegunn/fzf.vim) and [NERDTree](https://github.com/scrooloose/nerdtree):

| | |
|-|-|
| **Edit file in same directory as current file** | `:e %%/` |

### Buffers
Also living without [fzf.vim](https://github.com/junegunn/fzf.vim):

| | |
|-|-|
| **List buffers** | `ls` |
| **Switch to buffer by name** | `:b <name><tab>` |

### Version control
There's no equivalent for [GitGutter](https://github.com/airblade/vim-gitgutter), so use `git diff`.
