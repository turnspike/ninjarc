# Ninjarc
Super minimal .rc files for traipsing around Other People's Servers™

# Why?

Get In And Get Out of some random server with color and comfort. Zero dependencies to install. No plugins. The only external tool used is [fuzzy-finder](https://github.com/junegunn/fzf/). This is an experiment in minimalism.

![ninjarc screenshot](https://github.com/turnspike/ninjarc/raw/master/screenshot.png)

# Installation
```sh
mkdir -p ~/.config && git clone https://github.com/turnspike/ninjarc.git ~/.config/ninjarc && chmod u+x ~/.config/ninjarc/install.sh && ~/.config/ninjarc/install.sh
```

Ninjarc will skip existing files by default. To force overwrite, run install.sh with the -f param:
```sh
~/ninjarc/install.sh -f
```

TODO: add option to skip installation of Vim settings.

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

### Fuzzy finder

| Action | Command |
|-|-|
| **Search by filename in subdirs** | `<c-t>` |
| **Find and edit in vim** | `vim <c-t>` |
| **Search history** | `<c-r>` |
| **???** | `<alt-c>` |
| **Grep in subdirs** | `fzg<enter>` |
| **Find file and cd to subdir** | `cdf<enter>` |
| **Cd to git root** | `cdr<enter>` |

---
# Vim notes

Minimal plugins, mimimal config.

## Living without plugins

Related video: [How to do 90% of what plugins do with just Vim](https://www.youtube.com/watch?v=XA2WjJbmmoM_)

### Commenting
Living without [vim-commentary](https://github.com/tpope/vim-commentary):

| Action | Command |
|-|-|
| **Comment a single line** | `I// <Esc>` |
| **Uncomment a single line** | `^dw` |
| **Comment several lines** | `<c-v>jjj` <br> `I//<esc>` |
| **Uncomment several lines** | `<c-v>jjj` <br> `2x<esc>` |

### Quoting
Living without [vim-surround](https://github.com/tpope/vim-surround):

| Action | Command |
|-|-|
| **Quote a word** | `ciw'Ctrl+r"` <br> *or* <br> `ciw '' Esc P` |
| **Unquote a word** | `di'hPl2x` |
| **Change single quotes to double quotes** | `va':s/\%V'\%V/"/g` |
| **Quote all words in a line** | `:s/\v(\S+)/"\1"/` |

### Files
Living without [fzf.vim](https://github.com/junegunn/fzf.vim) and [NERDTree](https://github.com/scrooloose/nerdtree):

| Action | Command |
|-|-|
| **Fuzzyish filename find** <br> will look in subdirs | `:f name*<tab>` <br> *or* <br> `:f *.ext<tab>` |
| **Edit file in same directory as current file** | `:e %%/` |
| **Open file browser** | `:E` |
| **Open file drawer** | `:Ve` |
| **Close file browser** | `:bd` |
| **Revert current file** | `:e!` |

### Buffers
Also living without [fzf.vim](https://github.com/junegunn/fzf.vim):

| Action | Command |
|-|-|
| **Buffer list** | `:b <tab>` |
| **Switch to buffer by name** | `:b partialname<tab>` <br> *or* <br> `:b <tab>partialname<tab>` |
| **Cycle through all buffers** | `:b <tab><tab>` |
| **List all buffers** | `ls` |

### Version control
There's no equivalent for [GitGutter](https://github.com/airblade/vim-gitgutter), so use `:!git diff`.

---
# Known bugs

* On MacOS, horizontal rules don't fit to new screen width when terminal is resized (tput cols is returning wrong value)
* On RHEL, install.sh -f won't force overwrite; workaround is to rm the relevant .rc files in ~ first
* Old versions of RHEL might not have go, so FZF will be unavailable
