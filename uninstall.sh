#!/usr/bin/env bash
# =====================================================================
#  Darky / Darkly - UNINSTALL script
#  Safely removes all traces of Darky and Darkly from known theme paths,
#  resets KDE settings to Breeze, and removes Flatpak overrides.
# =====================================================================

set -u

DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}"

c()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
ok() { printf '\033[1;32m  ok\033[0m %s\n' "$1"; }
warn(){ printf '\033[1;33m  !!\033[0m %s\n' "$1"; }

echo
echo "  Darky / Darkly Uninstaller"
echo "  ---------------------------"
echo "  This will remove ALL traces of Darky and Darkly themes from your"
echo "  user directories and system Qt/KDE/GTK directories, then reset to Breeze."
echo
read -rp "  Continue? [y/N] " ans
[[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]] || { echo "Aborted."; exit 0; }

# =====================================================================
# 1. Remove from User Directories
# =====================================================================
c "Removing Darky/Darkly from user directories..."

# Color Schemes
rm -f "$DATA/color-schemes/Darky.colors"
rm -f "$DATA/color-schemes/Darkly.colors"

# Plasma Style
rm -rf "$DATA/plasma/desktoptheme/Darky"
rm -rf "$DATA/plasma/desktoptheme/Darkly"

# GTK Themes
rm -rf "$DATA/themes/Darky"
rm -rf "$DATA/themes/Darkly"

# Config files
rm -f "$CONF/darkyrc"
rm -f "$CONF/darklyrc"

# GTK4 libadwaita overrides
rm -f "$CONF/gtk-4.0/gtk-darky.css"
rm -rf "$CONF/gtk-4.0/darky-gtk-assets"
rm -rf "$CONF/gtk-4.0/darkly-gtk-assets"
# Restore gtk.css if we backed it up
if ls "$CONF/gtk-4.0/gtk.css.bak.darky."* 1> /dev/null 2>&1; then
    mv "$CONF/gtk-4.0/gtk.css.bak.darky."* "$CONF/gtk-4.0/gtk.css" 2>/dev/null
    ok "Restored original gtk-4.0/gtk.css from backup"
fi

ok "User directories cleaned"

# =====================================================================
# 2. Remove Compiled System Files (Qt6 / KWin / KCM)
# =====================================================================
c "Removing compiled Darky/Darkly system files..."

# Attempt make uninstall if build dir still exists in /tmp
if [[ -d "/tmp/darky-build" ]] && [[ -f "/tmp/darky-build/Makefile" ]]; then
  ( cd /tmp/darky-build && sudo make uninstall ) 2>/dev/null && ok "Ran 'make uninstall' from build directory"
fi

# Fallback: Manually remove system plugins (covers Qt6/KF6 paths on Debian/Ubuntu/Fedora)
# We search ONLY inside /usr/lib and /usr/share to be safe.
sudo find /usr/lib /usr/lib64 /usr/share -iname "*darky*" -exec rm -rf {} + 2>/dev/null
sudo find /usr/lib /usr/lib64 /usr/share -iname "*darkly*" -exec rm -rf {} + 2>/dev/null

ok "System directories cleaned"

# =====================================================================
# 3. Reset KDE Configuration to Breeze
# =====================================================================
c "Resetting KDE theme configuration to Breeze..."
KW=kwriteconfig6; command -v kwriteconfig6 &>/dev/null || KW=kwriteconfig5

# App Style
 $KW --file kdeglobals --group KDE --key widgetStyle Breeze 2>/dev/null
# Window Decoration
 $KW --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze 2>/dev/null
 $KW --file kwinrc --group org.kde.kdecoration2 --key theme Breeze 2>/dev/null
# Color Scheme
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark &>/dev/null || plasma-apply-colorscheme Breeze &>/dev/null
else
    $KW --file kdeglobals --group General --key ColorScheme BreezeDark 2>/dev/null
fi
# Plasma Style
command -v plasma-apply-desktoptheme &>/dev/null && plasma-apply-desktoptheme default &>/dev/null
# GTK Theme (reset via gsettings)
if command -v gsettings &>/dev/null; then
    gsettings reset org.gnome.desktop.interface gtk-theme 2>/dev/null
    gsettings reset org.gnome.desktop.interface color-scheme 2>/dev/null
fi
 $KW --file kdeglobals --group KDE-GTK-Config --key gtkTheme "" 2>/dev/null

# Reload KWin
for q in qdbus6 qdbus qdbus-qt6; do
    command -v "$q" &>/dev/null && "$q" org.kde.KWin /KWin reconfigure &>/dev/null && break
done

ok "KDE configuration reset to Breeze"

# =====================================================================
# 4. Reset Flatpak Overrides
# =====================================================================
c "Resetting Flatpak overrides..."
if command -v flatpak &>/dev/null; then
    sudo flatpak override --unset-env=QT_STYLE_OVERRIDE 2>/dev/null
    sudo flatpak override --unset-env=QT_QPA_PLATFORMTHEME 2>/dev/null
    sudo flatpak override --no-filesystem=xdg-config/darkyrc:ro 2>/dev/null
    sudo flatpak override --no-filesystem=xdg-data/themes 2>/dev/null
    sudo flatpak override --no-filesystem=xdg-config/gtk-4.0 2>/dev/null
    sudo flatpak override --no-filesystem=xdg-data/color-schemes:ro 2>/dev/null

    echo
    read -rp "  Do you also want to uninstall the Darkly Flatpak runtime? [y/N] " fp
    if [[ "${fp,,}" == "y" || "${fp,,}" == "yes" ]]; then
        sudo flatpak uninstall --system -y org.kde.darkly 2>/dev/null || warn "Darkly flatpak runtime not found/already removed"
    fi
fi
ok "Flatpak overrides reset"

echo
echo "  Done! Every trace of Darky/Darkly has been removed."
echo "  Log out and back in to fully apply the Breeze default theme."
echo
