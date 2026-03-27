# Loadiine-pmOS

Recreation of the classic **Loadiine GX2** GUI (WiiU Game loader) as a lightweight, touch-friendly application launcher / home screen for **postmarketOS** mobile devices.

Goal: offer a simple/WiiU Homebrew Inspired interface to launch installed applications on phones running postmarketOS (Fairphone, PinePhone, Pixel 3a, etc.).

## Current status (March 2026)

Early prototype stage – UI focused

✅ Black background + animated floating bubbles  
✅ Grid view
✅ Settings screen (work in progress)  
✅ View switching (top center button)  
X Real app scanning & launching (.desktop files) – planned next  
X Touch gestures / swipe navigation | Currently only tapping buttons to navigate 
X Packaging for postmarketOS (apk)

## Screenshots
<img src="Screenshot_20260327_125559.png" width="300"/>

The app grid will be adjusted to display more apps per page, planned is a default of 3x5 (15 apps per page). But possibly will be adjusted for different screen sizes.

## Features planned / in discussion

- Scan `/usr/share/applications` + `~/.local/share/applications`
- Parse .desktop files (name, icon, Exec)
- Launch applications (via QProcess or Qt.openUrlExternally)
- Optional particle effects toggle


## Credits (Original Authors)
![Loadiine GX2 WiiU](https://github.com/dimok789/loadiine_gx2)
(dimok, Cyan, Maschell, n1ghty, dibas)

This project is not affiliated with the original authors. 

## Building & Running (Desktop)

### On desktop (quick testing – Arch etc.)

```bash
# Install dependencies (Qt6)
sudo pacman -S qt6-base qt6-declarative qt6-quickcontrols2 qt6-svg qt6-tools qtcreator

# Clone & run
git clone https://github.com/eelis-04/Loadiine-pmOS.git
cd Loadiine-pmOS
qmlscene main.qml    # or use Qt Creator 
