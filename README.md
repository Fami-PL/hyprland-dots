🌙 Hyprland + Noctalia v5 Dotfiles

> Personal CachyOS rice with Hyprland, Noctalia v5, and a touch of glassmorphism.

![OS](https://img.shields.io/badge/OS-CachyOS-1793D1?logo=linux)
![WM](https://img.shields.io/badge/WM-Hyprland-58A6FF?logo=wayland)
![Shell](https://img.shields.io/badge/Shell-Noctalia-8B5CF6?logo=wayland)
![Terminal](https://img.shields.io/badge/Terminal-Konsole-1D99F3?logo=kde)
---

## ✨ Overview

This is my personal dotfiles repository featuring a clean, minimal Hyprland setup powered by **Noctalia v5** — a modern Wayland desktop shell. Built from scratch after getting tired of pre-made "hyprland for noobs" configs that never quite worked right.

### What's Inside

- **Window Manager:** Hyprland (Wayland compositor)
- **Desktop Shell:** Noctalia v5 (bar, panels, notifications, lockscreen)
- **Terminal:** Konsole
- **Shell:** ZSH
- **Browser:** Helium Browser
- **File Manager:** Dolphin
- **Editor:** Kate,vim

---

## 🎨 Features

- **Glassmorphism blur** on bar, panels, and notifications
- **Floating bar** with rounded corners and subtle shadows
- **Wallhaven plugin** for easy wallpaper browsing
- **Hyprshot** integration for screenshots
- **GPU-optimized** environment variables (NVIDIA on desktop, Intel/AMD on laptop)
- **Media keys** support (volume, brightness, playback)

---

## 📦 Installation

You can use the install script or do it manually.

### Option 1 — Automatic (install script)

Installs all packages (official + AUR) and copies configs:

```bash
git clone https://github.com/Fami-PL/hyprland-dots.git
cd hyprland-dots
chmod +x install.sh

# Full automatic install
./install.sh --auto

# Or step-by-step manual mode
./install.sh --manual
```

### Option 2 — Manual

#### Prerequisites

```bash
# Install Hyprland and core dependencies
sudo pacman -S hyprland konsole dolphin vim kate

# Install Noctalia v5 from AUR
paru -S noctalia-git

# Install additional tools
sudo pacman -S brightnessctl wireplumber
paru -S hyprshot helium-browser-bin
```

#### Clone & Apply

```bash
# Clone the repository
git clone https://github.com/Fami-PL/hyprland-dots.git
cd hyprland-dots

# Create config directories
mkdir -p ~/.config/hypr ~/.config/noctalia ~/.config/fastfetch

# Copy Hyprland config
cp hyprland.conf ~/.config/hypr/
cp hyprland-gui.conf ~/.config/hypr/

# Copy Noctalia config
cp noctalia.toml ~/.config/noctalia/config.toml
cp noctalia-colors.json ~/.config/noctalia/colors.json
cp noctalia-settings.json ~/.config/noctalia/settings.json
cp noctalia-plugins.json ~/.config/noctalia/plugins.json

# Copy Fastfetch config
cp -r fastfetch ~/.config/

# Copy Konsole config
cp konsolerc ~/.config/

# Copy ZSH config
cp zshrc ~/.zshrc

# Reload Hyprland
hyprctl reload
```

#### Noctalia Config

Reload Noctalia config:

```bash
noctalia msg config-reload
```

---

## ⌨️ Keybinds

| Keybind | Action |
|---------|--------|
| `Super + Return` | Open terminal (konsole) |
| `Super + grave` | Open app launcher |
| `Super + Escape` | Toggle control center |
| `Super + S` | Open settings |
| `Super + L` | Lock screen |
| `Super + V` | Clipboard history |
| `Super + X` | Session menu (lock/logout/reboot/shutdown) |
| `Super + Shift + S` | Screenshot region (clipboard + freeze) |
| `Super + E` | File manager (dolphin) |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + T` | Toggle floating |
| `Super + [1-0]` | Switch workspace |
| `Super + Shift + [1-0]` | Move window to workspace |
| `Super + Arrows` | Move focus |
| `Super + Ctrl + Arrows` | Swap windows |
| `Super + Alt + Arrows` | Resize window |
| `XF86Audio*` | Volume controls |
| `XF86MonBrightness*` | Brightness controls |

### Mouse

| Binding | Action |
|---------|--------|
| `Super + LMB` | Move window |
| `Super + RMB` | Resize window |
| `Super + Scroll` | Switch workspace |

---

## 🖼️ Screenshots

<img width="2558" height="1440" alt="image" src="https://github.com/user-attachments/assets/40badc2c-2661-4e24-8153-a129b1e71be8" />


---

## 🔧 Customization

### Bar Appearance

Edit `~/.config/noctalia/config.toml` (sourced from `noctalia.toml`):

```toml
[bar.main]
position = "top"
margin_ends = 100      # Left/right inset
margin_edge = 5        # Top float gap
radius = 12            # Corner radius
background_opacity = 0.7
shadow = true
```

### Blur Intensity

Edit `~/.config/hypr/hyprland.conf`:

```ini
decoration {
    blur {
        enabled = true
        size = 3
        passes = 3
        vibrancy = 0.1696
    }
}
```

### Lockscreen Widgets

Add to `~/.config/noctalia/config.toml`:

```toml
[lockscreen_widgets]
enabled = true

[lockscreen_widgets.widget.clock_main]
type = "clock"
cx = 1600.0
cy = 120.0
box_width = 360.0
box_height = 120.0

[lockscreen_widgets.widget.clock_main.settings]
format = "{:%H:%M}"
```

Edit lockscreen layout:
```bash
noctalia msg lockscreen-widgets-edit
```

---

## 🧩 Plugins

### Wallhaven (Wallpapers)

```bash
# Enable in Noctalia Settings → Plugins
noctalia msg plugins enable noctalia/wallhaven

# Or toggle browser panel
noctalia msg panel-toggle noctalia/wallhaven:browser
```

---

## 🐛 Troubleshooting

### Noctalia doesn't start

```bash
# Check if running
pgrep -a noctalia

# Check logs
journalctl -xe | grep -i noctalia | tail -20

# Manual start for debugging
noctalia
```

### No blur on bar

Make sure `layerrule` is in `hyprland.conf`:

```ini
layerrule = blur, noctalia-bar-.*
layerrule = blur, noctalia-panel
layerrule = blur, noctalia-notification
```

### Config not loading

```bash
noctalia msg config-reload
# or
hyprctl reload
```

---

## 📁 Repository Structure

```
.
├── hyprland.conf              # Hyprland main config
├── hyprland-gui.conf          # Hyprland GUI settings (HyprMod)
├── noctalia.toml              # Noctalia v5 config (bar, panels)
├── noctalia-colors.json       # Noctalia color scheme
├── noctalia-settings.json     # Noctalia panel settings
├── noctalia-plugins.json      # Noctalia plugins config
├── fastfetch/
│   └── config.jsonc           # Fastfetch config
├── konsolerc                  # Konsole config
├── dots.profile               # Konsole profile (ZSH)
├── zshrc                      # ZSH shell config
├── install.sh                 # Installation script
├── uninstall.sh               # Uninstallation script
├── wallpaper/                 # Wallpapers
└── README.md
```

---

## 🗑️ Uninstall

Remove configs (with backup) or full uninstall:

```bash
# Remove only configs (backed up to ~/dotfiles-backup-*)
./uninstall.sh --configs-only

# Remove configs + optionally remove packages
./uninstall.sh --full
```

---

## 🙏 Credits

- [Hyprland](https://hyprland.org/) — Wayland compositor
- [Noctalia](https://noctalia.dev/) — Desktop shell
- [CachyOS](https://cachyos.org/) — Arch-based distro
- [Konsole](https://konsole.kde.org/) — Terminal emulator

---

## 📜 License

MIT License — feel free to use, modify, and share. See [LICENSE](./LICENSE) for details.

---

> **Note:** This is a personal configuration. The install script auto-detects your GPU and strips NVIDIA env vars on Intel/AMD systems.
