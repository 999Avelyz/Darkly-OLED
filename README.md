<div align="center">

# 🌑 Darky
**The Ultimate True-Black OLED Theme for KDE Plasma & GTK**

[![KDE Plasma](https://img.shields.io/badge/KDE-Plasma%206-blue?logo=kde&logoColor=white)](https://kde.org/plasma-desktop/)
[![Qt6](https://img.shields.io/badge/Qt-6-green?logo=qt&logoColor=white)](https://www.qt.io/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

</div>

Darky is not just a simple color scheme. It is a **complete and independent fork** of the famous Darkly theme, engineered specifically for OLED displays. We took the elegance of Darkly and pushed it to the limit: pure black backgrounds (`#000000`), physically turned-off pixels, infinite contrast, and zero compromises. 

No hidden "Darkly" under the hood. The entire C++ engine, window decorations, and GTK themes have been renamed and recompiled. In your system, there will be **only Darky**.

---

## 🧬 Origins

Every great theme has a lineage. Darky stands on the shoulders of giants:

 ➡️ **Breeze** (Official KDE) 
 ➡️ **Lightly** (by Luwx, archived) 
 ➡️ **Darkly** (by Bali10050, modern and active) 
 ➡️ **Darky** (Us! Pure OLED, independent fork)

---

## ⚙️ How it works and what it implements

Original Darkly uses dark gray backgrounds (e.g., `#222222`). On an OLED display, these pixels stay on, using battery and reducing contrast. Darky solves this problem at the root:

*   🖤 **True Black (`#000000`)**: Window background, views, panels, and the `Complementary` group are pure black. Pixels physically turn off.
*   🧩 **Buttons and Tooltips at `#161616`**: If everything was `#000000`, buttons would disappear into the background. We used a minimal gray (only 22 levels above black) to keep things visible without sacrificing the OLED effect.
*   🚫 **Disabled Inactive Tint**: Background windows are no longer tinted gray (`ColorEffect=0`), staying consistently black.
*   🛠️ **Checkbox Fix (GTK)**: Fixed the "broken" checkbox bug (red square) in GTK apps like Protontricks, by increasing border contrast and adding a fallback to system icons.

### Architecture:

1.  **Qt6 Engine (C++)**: The Darkly source code was cloned, entirely renamed from `Darkly` to `Darky` (including `.cpp`, `.json`, and `darkyrc` files), and recompiled. The result is a 100% native Qt6 plugin.
2.  **Window Decorations (KWin)**: The KWin plugin was renamed and compiled to draw rounded borders and shadows with the "Darky" identity.
3.  **GTK 2/3/4 & libadwaita Theme**: Stylesheets compiled from source with OLED colors baked in and assets renamed (`darky-gtk-assets`).
4.  **Flatpak**: Automated configuration for sandboxed apps. It sets `QT_STYLE_OVERRIDE=Darky`, `QT_QPA_PLATFORMTHEME=kde`, and read-only access to `darkyrc`.

---

## 🖥️ Where it applies

After installation, you will find **Darky** consistently in every section of the KDE System Settings:

*   🎨 **Colors** ➡️ `Darky` (Pure OLED color scheme)
*   🪟 **Application Style** ➡️ `Darky` (Compiled Qt6 rendering engine)
*   🖼️ **Window Decorations** ➡️ `Darky` (Compiled borders and shadows)
*   🌌 **Plasma Style** ➡️ `Darky` (Black panels and widgets)
*   🐧 **GNOME/GTK App Style** ➡️ `Darky` (GTK2/3/4/libadwaita)

Also, the theme is natively recognized by:
*   `gsettings` / `nwg-look`
*   Flatpak apps (Qt and GTK)

---

## 🚀 Installation

The process is fully automated. The script will install Qt6/KF6 dependencies, compile the Darky engine from local sources, install the GTK theme, and apply everything.

Clone the repository and enter the folder:

```bash
git clone https://github.com/999Avelyz/Darky.git
cd Darky
```

Make the script executable and run it:

```bash
chmod +x install.sh
./install.sh
```

> ⚠️ **IMPORTANT:** Do not use `sudo ./install.sh`. The script will ask for your password only when necessary for system commands (`apt`, `make install`). Running it as root would break the build folder permissions.

At the end, you will be asked if you also want to configure the Flatpak environment (recommended).

---

## 🗑️ Uninstallation

If you want to remove Darky and go back to the default KDE theme, you can use the provided script:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

---

## 📜 License

Darky inherits the license from the project it derives from. 
The Qt/C++ engine and Plasma style are under the **GNU General Public License v2.0**.
The GTK theme is under **LGPL-2.1**.

---

<div align="center">
  Made with 🖤 and turned-off pixels.<br>
  Special thanks to <a href="https://github.com/Bali10050/Darkly">Bali10050</a> for the great work on Darkly.
</div>
