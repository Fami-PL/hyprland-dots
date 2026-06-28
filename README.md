🌙 Hyprland + Noctalia v5 Dotfiles

> Personal CachyOS rice with Hyprland, Noctalia v5, and a touch of glassmorphism.

![OS](https://img.shields.io/badge/OS-CachyOS-1793D1?logo=arch-linux)
![WM](https://img.shields.io/badge/WM-Hyprland-58A6FF?logo=wayland)
![Shell](https://img.shields.io/badge/Shell-ZSH-F15A24?logo=zsh)
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
- **NVIDIA-optimized** environment variables
- **Media keys** support (volume, brightness, playback)

---

## 📦 Installation

### Prerequisites

```bash
# Install Hyprland and core dependencies
sudo pacman -S hyprland konsole dolphin vim kate

# Install Noctalia v5 from AUR
paru -S noctalia-git

# Install additional tools
sudo pacman -S brightnessctl wireplumber
paru -S hyprshot helium-browser-bin
```

### Clone & Apply

```bash
# Clone the repository
git clone https://github.com/Fami-PL/hyprland-dots.git
cd hyprland-dots

# Copy configs
cp -r hypr ~/.config/
cp -r noctalia ~/.config/
cp konsole/konsolerc ~/.config/
cp konsole/dots.profile ~/.local/share/konsole/
cp zsh/.zshrc ~/

# Reload Hyprland
hyprctl reload
```

### Noctalia Config

Make sure Noctalia v5 config exists:

```bash
mkdir -p ~/.config/noctalia
cp noctalia/config.toml ~/.config/noctalia/
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

Edit `~/.config/noctalia/config.toml`:

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
├── hypr/
│   └── hyprland.conf          # Hyprland main config
├── noctalia/
│   └── config.toml            # Noctalia v5 config
├── konsole/
│   ├── konsolerc              # Konsole main config
│   └── dots.profile           # Konsole profile
├── zsh/
│   └── .zshrc                 # ZSH shell config
└── README.md
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

> **Note:** This is a personal configuration. For laptops with Intel/AMD graphics, remove NVIDIA environment variables from `hyprland.conf`.
