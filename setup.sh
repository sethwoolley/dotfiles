#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/setup/common.sh

NEOVIM_VERSION="v0.11.3"
FORCE_INSTALL=""
ARCH=""

GIT_NAME_DEFAULT="Seth Woolley"
GIT_EMAIL_DEFAULT="seth.w.public@proton.me"

help () {
    echo "Usage: setup.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -n, --nvim        Install Neovim version (Default is $NEOVIM_VERSION)"
    echo "  -a, --arch        Architecture to use. Will try to work it out if not set."
    echo "  -f, --force       Force installation despite checks"
    echo "  --iamseth         Run with settings for Seth"
    echo ""
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0 ;;
        -n|--nvim) NEOVIM_VERSION="$2"; shift ;;
        -f|--force) FORCE_INSTALL=true ;;
        --iamseth) IAMSETH=true ;;
        -a|--arch) ARCH="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; help; exit 1 ;;
    esac
    shift
done

# check we cloned to the right place - pwd should be ~/.config/dotfiles
if [ "$(realpath $(pwd))" != "$(realpath $HOME/.config/dotfiles)" ] && [ -z "$FORCE_INSTALL" ]; then
    warn "This script assumes you've cloned the repo to and are running from ~/.config/dotfiles, but I don't think you have."
    warn "Rerun with --force to continue anyway."
    exit 1
fi

# check we are running ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ] && [ -z "$FORCE_INSTALL" ]; then
        warn "This script is designed for Ubuntu, but your OS is detected as $NAME."
        warn "Rerun with --force to continue anyway."
        exit 1
    fi
else
    warn "/etc/os-release not found. Cannot determine OS."
    if [ -z "$FORCE_INSTALL" ]; then
        warn "Rerun with --force to continue anyway."
        exit 1
    fi
fi

if [ -z "$ARCH" ] ; then
    ARCH=$(uname -a | grep -Eo '(x86_64|arm64)' | head -n1)
fi

banner "Starting setup for arch $ARCH"
run mkdir -p ~/bin
run mkdir -p ~/code
ln_safe ~/.config/dotfiles/.gitconfig ~/.gitconfig
ln_safe ~/.config/dotfiles/scripts/ ~/scripts/

# set ~/.gituser file
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    GIT_NAME="$GIT_USER"
    GIT_EMAIL="$GIT_EMAIL"
elif [ "$IAMSETH" == "true" ]; then
    GIT_NAME="$GIT_NAME_DEFAULT"
    GIT_EMAIL="$GIT_EMAIL_DEFAULT"
else
    read -p "Enter your git user.name: " GIT_NAME
    read -p "Enter your git user.email: " GIT_EMAIL
fi
cat << EOF > ~/.gituser
[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
EOF

banner "Installing nvim from appimage"
NEOVIM_VERSION=$NEOVIM_VERSION setup/install_nvim.sh

banner "Installing wezterm"
setup/install_wezterm.sh

banner "Symlink i3"
ln_safe ~/.config/dotfiles/i3 ~/.config/i3

banner "Installing fzf from git"
setup/install_fzf.sh

banner "Setting wallpaper"
setup/set_wallpaper.sh

banner "Writing .bashrc redirect"
if [ -f ~/.bashrc ]; then
    run mv ~/.bashrc ~/.bashrc.bak
    warn "Existing .bashrc moved to .bashrc.bak"
fi
cat << EOF > ~/.bashrc
# My .bashrc is stored in .config/dotfiles/.bashrc
if [ -f "$HOME/.config/dotfiles/.bashrc" ]; then
    source "$HOME/.config/dotfiles/.bashrc"
fi
EOF
