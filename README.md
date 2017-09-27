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
````
git clone https://github.com/turnspike/ninjarc.git ~/ninjarc && chmod u+x ~/ninjarc/install.sh && ~/ninjarc/install.sh
````

Ninjarc will skip existing files by default. To force overwrite, run install.sh with the -f param:
````
~/ninjarc/install.sh -f
````

---

# User Settings

You might want to add your own user settings eg git username. Just:
````
cp -f ~/ninjarc/*.user ~
````

Then edit to taste. This step is not usually needed for general sysadmin work on random servers.

---

# Vim notes

No plugins, mimimal config.

## Living without plugins

### How do I comment?

**Commenting a single line:**
````
I// <Esc>
````

**Uncommenting a single line:**
````
^dw
````

**Commenting several lines:**
````
<c-v>jjj
I//<esc>
````

**Uncommenting several lines:**
````
<c-v>jjj
2x<esc>
````
### How do I quote/unquote?

**Quote a word, using single quotes**
````
ciw'Ctrl+r"
````
or
````
ciw '' Esc P
````

**Unquote a word that's enclosed in single quotes**
````
di'hPl2x
````

**Change single quotes to double quotes**
````
va':s/\%V'\%V/"/g
````

**Quote all words in a line**
````
:s/\v(\S+)/"\1"/
````
