#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

help () {
    echo "Usage: install_bat.sh [options]"
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

# check existing bat
if command -v batcat --version >/dev/null 2>&1; then
    ok "batcat is already installed"
    if [ -z "$FORCE" ]; then
        ok "Rerun with --force to install anyway"
        exit 0
    fi
fi

run sudo apt install bat -y

run mkdir $HOME/.config/bat/

ln_safe $DOTFILES_ROOT/misc/bat-config $HOME/.config/bat/config 
