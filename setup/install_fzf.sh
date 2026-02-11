#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

help () {
    echo "Usage: install_fzf.sh [options]"
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

# check if directory exists
if [ -d "$HOME/.fzf" ]; then
    ok "fzf is already installed"
    if [ -z "$FORCE" ]; then
        ok "Rerun with --force to install anyway"
        exit 0
    fi
    run rm -rf $HOME/.fzf
fi

run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
run ~/.fzf/install --no-update-rc --key-bindings --completion --no-zsh --no-fish
