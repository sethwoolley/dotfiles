# My dotfiles

These are my personal dotfiles.

`setup.sh` is used to set up a new machine. It currently assumes the machine is ubuntu-based because that's what I use.

## A note on .bashrc

`setup.sh` will write a new `.bashrc` in the home directory that sources the `.bashrc` in this repo. The intention of this is so that I can also have a work-specific one that is not in this repo.

The work-specific bashrc can export `$DOTFILE_HOSTNAME` to tell this bashrc what it wants the hostname to appear as in the prompt.

## Dependencies

wezterm depends on Fira Code Nerd Font, which you can get from:
https://www.nerdfonts.com/font-downloads
