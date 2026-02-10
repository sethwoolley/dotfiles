#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

# default to v0.11.3
NEOVIM_VERSION=${NEOVIM_VERSION:-"v0.11.3"}

run mkdir -p ~/bin/

run wget -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim-linux-$ARCH.appimage
run chmod u+x ~/bin/nvim.appimage
run ln -s ~/bin/nvim.appimage ~/bin/nvim

# symlink config to dotfiles
run ln -s ~/.config/dotfiles/nvim ~/.config/nvim

run ~/bin/nvim --version
if [ $? -ne 0 ]; then
    warn "Neovim installation failed"
fi
