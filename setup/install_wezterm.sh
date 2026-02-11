#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

help () {
    echo "Usage: install_wezterm.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -f, --force       Force installation despite checks"
    echo ""
}

# command line parameters
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0 ;;
        -f|--force) FORCE=true ;;
        *) echo "Unknown parameter passed: $1"; help; exit 1 ;;
    esac
    shift
done

# check existing wezterm
if command -v wezterm --version >/dev/null 2>&1; then
    ok "wezterm is already installed"
    if [ -z "$FORCE" ]; then
        ok "Rerun with --force to install anyway"
        exit 0
    fi
fi

# yoinked from https://wezterm.org/install/linux.html
run curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
run sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
run sudo apt install wezterm -y

# symlink config to dotfiles
ln_safe ~/.config/dotfiles/wezterm ~/.config/wezterm

run wezterm --version
if [ $? -ne 0 ]; then
    warn "Wezterm installation failed"
fi
