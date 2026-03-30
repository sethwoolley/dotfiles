#!/bin/bash

read -p "This will remove the snap version of Firefox and install the deb version. Do you want to continue? (y/n) " -n 1 -r
echo    # move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo apt remove --purge firefox
    sudo snap remove firefox
    sudo add-apt-repository ppa:mozillateam/ppa -y
    sudo apt update
    sudo tee /etc/apt/preferences.d/mozilla-firefox <<EOF
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
    sudo apt install firefox -y

    sudo update-alternatives --set firefox /usr/bin/firefox-deb
    xdg-settings set default-web-browser firefox.desktop
    xdg-mime default firefox.desktop text/html
    xdg-mime default firefox.desktop x-scheme-handler/http
    xdg-mime default firefox.desktop x-scheme-handler/https

else
    echo "Operation cancelled."
fi
