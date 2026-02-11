#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

# default to v0.11.3
NEOVIM_VERSION=${NEOVIM_VERSION:-"v0.11.3"}

help () {
    echo "Usage: install_nvim.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -V, --version     Install Neovim version (Default is $NEOVIM_VERSION)"
    echo "  -f, --force       Force installation despite checks"
    echo ""
}

# command line parameters
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0 ;;
        -n|--nvim) NEOVIM_VERSION="$2"; shift ;;
        -f|--force) FORCE=true ;;
        *) echo "Unknown parameter passed: $1"; help; exit 1 ;;
    esac
    shift
done

# check existing nvim vs requested NEOVIM_VERSION
if command -v nvim >/dev/null 2>&1; then
    INSTALLED_VERSION=$(nvim --version | head -n1 | awk '{print $2}')
    if [ "$INSTALLED_VERSION" = "${NEOVIM_VERSION#v}" ]; then
        ok "Neovim $NEOVIM_VERSION is already installed"
        exit 0
    else
        warn "Neovim version $INSTALLED_VERSION is installed, but $NEOVIM_VERSION is required."
        if [ -z "$FORCE" ]; then
            warn "Rerun with --force to continue anyway."
            exit 1
        fi
    fi
fi

run mkdir -p ~/bin/

run wget -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim-linux-$ARCH.appimage
run chmod u+x ~/bin/nvim.appimage
ln_safe ~/bin/nvim.appimage ~/bin/nvim

# symlink config to dotfiles
ln_safe ~/.config/dotfiles/nvim ~/.config/nvim

run ~/bin/nvim --version
if [ $? -ne 0 ]; then
    warn "Neovim installation failed"
fi
