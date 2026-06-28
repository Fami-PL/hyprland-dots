#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()   { echo -e "${RED}[ERR]${NC} $1"; }

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

FILES_TO_REMOVE=(
  "$HOME/.config/hypr/hyprland.conf"
  "$HOME/.config/hypr/hyprland-gui.conf"
  "$HOME/.config/noctalia/config.toml"
  "$HOME/.config/noctalia/colors.json"
  "$HOME/.config/noctalia/plugins.json"
  "$HOME/.config/fastfetch/config.jsonc"
  "$HOME/.config/konsolerc"
  "$HOME/.local/share/konsole/dots.profile"
  "$HOME/.local/share/konsole/dots-V2.profile"
  "$HOME/.local/share/konsole/Dots.colorscheme"
  "$HOME/.config/gtk-3.0/settings.ini"
  "$HOME/.config/gtk-4.0/settings.ini"
  "$HOME/.zshrc"
)

DIRS_TO_REMOVE=(
  "$HOME/.config/hypr"
  "$HOME/.config/noctalia"
  "$HOME/.config/fastfetch"
)

remove_configs() {
  echo ""
  warn "This will remove all dotfiles configs and back them up to:"
  warn "  $BACKUP_DIR"
  echo ""

  local choice
  read -rp "Continue? [y/N] " choice
  if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
  fi

  mkdir -p "$BACKUP_DIR"

  info "Backing up and removing config files..."
  for f in "${FILES_TO_REMOVE[@]}"; do
    if [[ -f "$f" ]]; then
      mkdir -p "$(dirname "$BACKUP_DIR/$f")"
      cp "$f" "$BACKUP_DIR/$f"
      rm "$f"
      ok "Removed: $f"
    else
      info "Skipped (not found): $f"
    fi
  done

  info "Removing config directories (if empty)..."
  for d in "${DIRS_TO_REMOVE[@]}"; do
    if [[ -d "$d" ]]; then
      rmdir "$d" 2>/dev/null && ok "Removed dir: $d" || info "Dir not empty, keeping: $d"
    fi
  done

  echo ""
  ok "Configs removed. Backup saved at: $BACKUP_DIR"
}

remove_packages() {
  echo ""
  warn "This will REMOVE packages installed by the dotfiles:"
  echo "  hyprland konsole dolphin vim kate"
  echo "  brightnessctl wireplumber fastfetch"
  echo "  networkmanager xdotool qt6ct"
  echo "  noctalia-git hyprshot helium-browser-bin"
  echo ""

  local choice
  read -rp "Remove packages? [y/N] " choice
  if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    info "Skipping package removal."
    return
  fi

  if command -v paru &>/dev/null; then
    info "Removing AUR packages..."
    paru -Rns --noconfirm noctalia-git hyprshot helium-browser-bin 2>/dev/null || true
    info "Removing official packages..."
    sudo pacman -Rns --noconfirm hyprland konsole dolphin vim kate brightnessctl wireplumber fastfetch xdotool qt6ct 2>/dev/null || true
    ok "Packages removed"
  else
    sudo pacman -Rns --noconfirm hyprland konsole dolphin vim kate brightnessctl wireplumber fastfetch networkmanager xdotool qt6ct noctalia-git hyprshot helium-browser-bin 2>/dev/null || true
    ok "Packages removed"
  fi
}

full_uninstall() {
  echo ""
  info "=== Full Uninstall ==="
  remove_configs

  local choice
  read -rp "Also remove packages? [y/N] " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    remove_packages
  fi

  echo ""
  ok "Uninstall complete."
  info "Backup of your configs: $BACKUP_DIR"
}

usage() {
  echo "Usage: $0 [--full | --configs-only | --help]"
  echo ""
  echo "  --full           Remove configs + packages"
  echo "  --configs-only   Remove only config files (default)"
  echo "  --help           Show this help"
  exit 0
}

case "${1:-}" in
  --full|-f)
    full_uninstall
    ;;
  --configs-only|-c|"")
    remove_configs
    ;;
  --help|-h)
    usage
    ;;
  *)
    err "Unknown option: $1"
    usage
    ;;
esac
