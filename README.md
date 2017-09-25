# Ninjarc
Super minimal .rc files for traipsing around Other People's Servers™

# Why?

If you just want to Get In And Get Out of some random server and you still want some color and comfort. This is a minimal setup for hit-and-run. If you're after something more featurful, you might like Aetherwolf: https://github.com/turnspike/aetherwolf

# Installation
````
git clone https://github.com/turnspike/ninjarc.git ~/ninjarc && chmod u+x ~/ninjarc/install.sh && ~/ninjarc/install.sh
````

Ninjarc will skip existing files by default. To force overwrite, run install.sh with the -f param:
````
~/ninjarc/install.sh -f
````

---

# Vim notes

No plugins, mimimal config.

## How do I comment in Vim without plugins?

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
