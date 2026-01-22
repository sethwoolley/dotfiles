#!/bin/bash

# TODO:
# - Check for sudo
#   - apt install nvim/wezterm rather than appimage
#   - install rg
# - Check OS installing on (currently ubuntu only)

NEOVIM_VERSION="v0.11.3"
FORCE_INSTALL=""
ARCH=""

GIT_NAME_DEFAULT="Seth Woolley"
GIT_EMAIL_DEFAULT="seth.w.public@proton.me"

COLOUR_RESET='\e[0m'
COLOUR_YELLOW='\e[38;5;228m'
COLOUR_ORANGE='\e[38;5;208m'

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

banner () {
    # banner with yellow (i like yellow)
    echo -e ""
    echo -e "${COLOUR_YELLOW}============= $1 =============${COLOUR_RESET}"
    echo -e ""
}

warn () {
    # warn with orange (i hate orange)
    echo -e "${COLOUR_ORANGE}WARNING: $1${COLOUR_RESET}"
}

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
mkdir -p ~/bin
mkdir -p ~/scripts
mkdir -p ~/code
ln -s ~/.config/dotfiles/.gitconfig ~/.gitconfig

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
wget -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim-linux-$ARCH.appimage
chmod u+x ~/bin/nvim.appimage
ln -s ~/bin/nvim.appimage ~/bin/nvim

# symlink config to dotfiles
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

~/bin/nvim --version
if [ $? -ne 0 ]; then
    warn "Neovim installation failed"
fi

banner "Installing wezterm"
# yoinked from https://wezterm.org/install/linux.html
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt install wezterm

# symlink config to dotfiles
ln -s ~/.config/dotfiles/wezterm ~/.config/wezterm

wezterm --version
if [ $? -ne 0 ]; then
    warn "Wezterm installation failed"
fi

banner "Symlink i3"
ln -s ~/.config/dotfiles/i3 ~/.config/i3

banner "Installing fzf from git"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-update-rc --key-bindings --completion --no-zsh --no-fish

banner "Writing .bashrc redirect"
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.bak
    warn "Existing .bashrc moved to .bashrc.bak"
fi
cat << EOF > ~/.bashrc
# My .bashrc is stored in .config/dotfiles/.bashrc
if [ -f "$HOME/.config/dotfiles/.bashrc" ]; then
    source "$HOME/.config/dotfiles/.bashrc"
fi
EOF

warn "Remember to set git config user.email"
