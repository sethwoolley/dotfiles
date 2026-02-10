#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
run ~/.fzf/install --no-update-rc --key-bindings --completion --no-zsh --no-fish
