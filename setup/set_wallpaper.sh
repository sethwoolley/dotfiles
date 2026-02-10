#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/common.sh

WALLPAPER="$DOTFILES_ROOT/wallpaper.bmp"

if command -v gsettings >/dev/null 2>&1; then
    # set the wallpaper using gsettings
    run "gsettings set org.gnome.desktop.background picture-uri $WALLPAPER"
    run "gsettings set org.gnome.desktop.background picture-uri-dark $WALLPAPER"
    run "gsettings set org.gnome.desktop.background picture-options 'wallpaper'"
    # workaround for tiling: https://gitlab.gnome.org/GNOME/mutter/-/issues/1473#note_2532190
    run "gsettings set org.gnome.desktop.background color-shading-type vertical"
    ok "Background set!"
else
    warn "gsettings not found. Please set the wallpaper manually."
fi
