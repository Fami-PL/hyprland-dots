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

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

OFFICIAL_PACKAGES=(
  hyprland konsole dolphin vim kate
  brightnessctl wireplumber fastfetch
  networkmanager xdotool qt6ct
)

AUR_PACKAGES=(
  noctalia-git hyprshot helium-browser-bin
)

detect_aur_helper() {
  if command -v paru &>/dev/null; then
    echo "paru"
  elif command -v yay &>/dev/null; then
    echo "yay"
  else
    echo ""
  fi
}

install_official() {
  info "Installing official packages..."
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
    ok "Official packages installed"
  else
    warn "pacman not found, skipping official packages"
  fi
}

install_aur() {
  local aur_helper
  aur_helper=$(detect_aur_helper)

  if [[ -z "$aur_helper" ]]; then
    info "No AUR helper found. Installing paru..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    aur_helper="paru"
    ok "paru installed"
  fi

  info "Installing AUR packages..."
  "$aur_helper" -S --needed --noconfirm "${AUR_PACKAGES[@]}"
  ok "AUR packages installed"
}

copy_configs() {
  info "Copying configs..."

  mkdir -p "$HOME/.config/hypr"
  mkdir -p "$HOME/.config/noctalia"
  mkdir -p "$HOME/.config/fastfetch"

  cp "$DOTFILES_DIR/hyprland.conf" "$HOME/.config/hypr/"
  cp "$DOTFILES_DIR/hyprland-gui.conf" "$HOME/.config/hypr/"
  cp "$DOTFILES_DIR/noctalia.toml" "$HOME/.config/noctalia/config.toml"
  cp "$DOTFILES_DIR/noctalia-colors.json" "$HOME/.config/noctalia/colors.json"
  cp "$DOTFILES_DIR/noctalia-settings.json" "$HOME/.config/noctalia/settings.json"
  cp "$DOTFILES_DIR/noctalia-plugins.json" "$HOME/.config/noctalia/plugins.json"

  cp -r "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME/.config/fastfetch/"
  cp "$DOTFILES_DIR/konsolerc" "$HOME/.config/"
  cp "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

  ok "Configs copied"
}

set_zsh_default() {
  if [[ "$SHELL" != "$(which zsh 2>/dev/null)" ]]; then
    if command -v zsh &>/dev/null; then
      info "Setting ZSH as default shell..."
      chsh -s "$(which zsh)"
      ok "Default shell set to ZSH (reboot or re-login to apply)"
    else
      warn "ZSH not found, skipping"
    fi
  else
    ok "ZSH is already default shell"
  fi
}

reload_hyprland() {
  if command -v hyprctl &>/dev/null; then
    info "Reloading Hyprland..."
    hyprctl reload 2>/dev/null && ok "Hyprland reloaded" || warn "Could not reload Hyprland (not running?)"
  fi
}

reload_noctalia() {
  if command -v noctalia &>/dev/null; then
    info "Reloading Noctalia config..."
    noctalia msg config-reload 2>/dev/null && ok "Noctalia reloaded" || warn "Noctalia not running, will load on next start"
  fi
}

manual_install() {
  echo ""
  info "=== Manual Installation ==="
  echo ""
  info "Step 1: Install official packages"
  echo "  sudo pacman -S --needed ${OFFICIAL_PACKAGES[*]}"
  echo ""
  info "Step 2: Install AUR packages"
  echo "  $(detect_aur_helper || echo "paru") -S --needed ${AUR_PACKAGES[*]}"
  echo ""
  info "Step 3: Copy configs"
  echo "  $DOTFILES_DIR/install.sh --auto"
  echo ""
  info "Step 4: Set ZSH as default shell"
  echo "  chsh -s \$(which zsh)"
  echo ""
  info "Step 5: Reload Hyprland"
  echo "  hyprctl reload"
  echo "  noctalia msg config-reload"
  echo ""

  local choice
  read -rp "Run copy configs now? [y/N] " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    copy_configs
    set_zsh_default
    reload_hyprland
    reload_noctalia
    ok "Manual setup complete!"
  else
    info "Skipping. You can run '$DOTFILES_DIR/install.sh --auto' later."
  fi
}

auto_install() {
  info "=== Automatic Installation ==="

  if [[ "$(id -u)" -eq 0 ]]; then
    err "Do not run this script as root!"
    exit 1
  fi

  install_official
  install_aur
  copy_configs
  set_zsh_default
  reload_hyprland
  reload_noctalia

  echo ""
  ok "=== Installation complete! ==="
  info "Reboot or re-login for all changes to take effect."
}

usage() {
  echo "Usage: $0 [--auto | --manual | --help]"
  echo ""
  echo "  --auto     Automatic installation (installs everything)"
  echo "  --manual   Manual step-by-step installation (default)"
  echo "  --help     Show this help"
  exit 0
}

case "${1:-}" in
  --auto|-a)
    auto_install
    ;;
  --manual|-m|"")
    manual_install
    ;;
  --help|-h)
    usage
    ;;
  *)
    err "Unknown option: $1"
    usage
    ;;
esac
