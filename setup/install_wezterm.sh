#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

# yoinked from https://wezterm.org/install/linux.html
run curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
run sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
run sudo apt install wezterm -y

# symlink config to dotfiles
run ln -s ~/.config/dotfiles/wezterm ~/.config/wezterm

run wezterm --version
if [ $? -ne 0 ]; then
    warn "Wezterm installation failed"
fi
