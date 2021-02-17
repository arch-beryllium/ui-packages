# ui-packages

This repo contains all required and some extra packages for several UIs.  
It self-updates every six hours and the packages live in
the [`packages`](https://github.com/arch-beryllium/plasma-mobile-packages/tree/packages) branch.  
To use it configure your `/etc/pacman.conf` like this:

```
[plasma-mobile]
Server = https://raw.githubusercontent.com/arch-beryllium/ui-packages/packages/plasma-mobile

[lomiri]
Server = https://raw.githubusercontent.com/arch-beryllium/ui-packages/packages/lomiri
```