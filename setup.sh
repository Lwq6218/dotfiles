#!/usr/bin/env bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 备份目录
BACKUP_DIR="$HOME/backup/dotfiles_bak"

# 日志函数
log() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# 打印标题
print_header() {
  echo -e "${CYAN}┌─────────────────────────────────────────────┐${NC}"
  echo -e "${CYAN}│            Dotfiles Setup Script            │${NC}"
  echo -e "${CYAN}└─────────────────────────────────────────────┘${NC}"
  echo ""
}

# 创建软链接函数
create_symlink() {
  local src="$1"
  local dest="$2"

  # 检查源文件/目录是否存在
  if [ ! -e "$src" ]; then
    warning "Source file/directory doesn't exist: $src, skipping..."
    return 1
  fi

  # readlink -f 在某些系统可能不可用，改用更兼容的方式
  if [ -L "$dest" ]; then
    local target=$(readlink "$dest")
    # 检查是否为相对路径，如果是，转换为绝对路径
    if [[ ! "$target" = /* ]]; then
      target="$(dirname "$dest")/$target"
    fi

    # 规范化路径
    if [ "$target" = "$(realpath "$src")" ]; then
      log "Link already exists and points to the correct location: $dest → $src"
      return 0
    fi
  fi

  # 检查目标是否已存在
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    # 创建备份目录（如果不存在）
    mkdir -p "$BACKUP_DIR"

    # 创建基于目标文件路径的备份路径
    local rel_path="${dest#/}"   # 去掉开头的斜杠
    rel_path="${rel_path//\//_}" # 将路径中的斜杠替换为下划线

    # 备份现有文件/目录
    local backup_file="${BACKUP_DIR}/${rel_path}.$(date +%Y%m%d%H%M%S)"

    mv "$dest" "$backup_file"
    success "Backed up $dest → $backup_file"
  fi

  # 创建软链接
  ln -sf "$(realpath "$src")" "$dest"
  success "Created symlink: $dest → $src"
  return 0
}

# 检查并安装AUR助手
check_install_aur_helper() {
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
    success "AUR helper detected: yay"
  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
    success "AUR helper detected: paru"
  else
    echo -e "${YELLOW}No AUR helper detected. Please choose one to install:${NC}"
    echo "1) yay"
    echo "2) paru"
    echo -n "Please select [1/2]: "
    read -r choice

    case $choice in
    1 | "")
      log "Installing yay..."
      # 直接使用pacman安装yay
      if sudo pacman -S --needed --noconfirm yay; then
        AUR_HELPER="yay"
        success "yay installation completed"
      else
        error "Failed to install yay with pacman"
        return 1
      fi
      ;;
    2)
      log "Installing paru..."
      # 直接使用pacman安装paru
      if sudo pacman -S --needed --noconfirm paru; then
        AUR_HELPER="paru"
        success "paru installation completed"
      else
        error "Failed to install paru with pacman"
        return 1
      fi
      ;;
    *)
      error "Invalid option, defaulting to yay..."
      # 直接使用pacman安装yay
      if sudo pacman -S --needed --noconfirm yay; then
        AUR_HELPER="yay"
        success "yay installation completed"
      else
        error "Failed to install yay with pacman"
        return 1
      fi
      ;;
    esac
  fi

  return 0
}

# 安装软件包
install_packages() {
  log "Updating system..."
  if [ "$AUR_HELPER" = "yay" ]; then
    yay -Syu --noconfirm || {
      error "System update failed"
      return 1
    }
  else
    paru -Syu --noconfirm || {
      error "System update failed"
      return 1
    }
  fi
  success "System update completed"

  # 询问安装类型
  echo -e "${CYAN}Please choose installation type:${NC}"
  echo "1) Full installation (Desktop environment + Terminal tools)"
  echo "2) Terminal tools only"
  echo -n "Please select [1/2]: "
  read -r install_type

  log "Installing packages..."

  # 实用工具和终端相关软件包
  TERMINAL_PACKAGES=(
    # 终端实用工具
    "curl" "wget" "zsh" "fish" "bat" "starship" "fastfetch" "lazygit" "neovim"
    "nodejs" "go" "pnpm" "ffmpeg" "p7zip" "jq" "poppler" "fd" "ripgrep"
    "fzf" "zoxide" "imagemagick" "unzip" "resvg" "yazi" "tmux" "less"
  )

  # 完整安装的软件包列表 (包括桌面环境)
  FULL_PACKAGES=(
    # 字体
    "inter-font"
    "otf-apple-pingfang"
    "ttf-apple-emoji"
    "ttf-jetbrains-mono-nerd"
    "ttf-maplemono-nf-cn-unhinted"

    # 窗口管理和桌面环境
    "hyprland" "hypridle" "swww" "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk"
    "archlinux-xdg-menu" "waybar" "rofi-wayland" "dunst" "cliphist" "wl-clipboard" "wf-recorder"
    "uwsm" "hyprlock" "hyprpicker" "hyprpolkitagent" "nwg-displays" "bc"

    # 网络和蓝牙
    "blueman" "bluez" "bluez-utils" "network-manager-applet"

    # 文件管理和浏览器
    "dolphin" "ark" "zen-browser-bin"

    # 输入法和查看器
    "fcitx5-rime" "fcitx5-im" "eog" "pacman-contrib" "slurp" "grim" "okular"

    # 音频和亮度控制
    "pavucontrol" "brightnessctl" "syshud" "libnotify"

    # Qt和主题
    "qt5-wayland" "qt6-wayland" "breeze" "breeze-gtk" "qt6ct-kde"

    # 音频
    "pipewire" "pipewire-alsa" "pipewire-audio" "pipewire-jack" "pipewire-pulse"
    "gst-plugin-pipewire" "wireplumber"

    #终端
    "kitty" "wezterm-git"
  )

  # 根据用户选择安装不同的包集
  case $install_type in
  2)
    log "Installing terminal tools only..."
    if [ "$AUR_HELPER" = "yay" ]; then
      yay -S --needed --noconfirm "${TERMINAL_PACKAGES[@]}" || { warning "Some packages may have failed to install"; }
    else
      paru -S --needed --noconfirm "${TERMINAL_PACKAGES[@]}" || { warning "Some packages may have failed to install"; }
    fi
    success "Terminal tools installation completed"
    ;;
  1 | *)
    log "Installing full package set..."
    # 先安装终端工具
    if [ "$AUR_HELPER" = "yay" ]; then
      yay -S --needed --noconfirm "${TERMINAL_PACKAGES[@]}" || { warning "Some terminal packages may have failed to install"; }
      yay -S --needed --noconfirm "${FULL_PACKAGES[@]}" || { warning "Some desktop packages may have failed to install"; }
    else
      paru -S --needed --noconfirm "${TERMINAL_PACKAGES[@]}" || { warning "Some terminal packages may have failed to install"; }
      paru -S --needed --noconfirm "${FULL_PACKAGES[@]}" || { warning "Some desktop packages may have failed to install"; }
    fi
    success "Full installation completed"
    ;;
  esac

  # 存储安装类型供后续使用
  export INSTALL_TYPE=$install_type
  return 0
}

# 创建dotfiles软链接
link_dotfiles() {
  log "Creating symlinks for dotfiles..."

  DOTFILES_DIR="$HOME/dotfiles"

  # 检查dotfiles目录是否存在
  if [ ! -d "$DOTFILES_DIR" ]; then
    error "dotfiles directory doesn't exist: $DOTFILES_DIR"
    return
  fi

  # 检查安装类型
  local install_type=${INSTALL_TYPE:-1} # 默认为完整安装

  # 常见配置目录
  log "Creating symlinks for configuration directories..."

  # 终端相关配置目录
  TERMINAL_DIRS=(
    "bat"
    "fish"
    "kitty"
    "lazygit"
    "nvim"
    "tmux"
    "wezterm"
    "yazi"
    "zsh"
    "starship"
    "git"
  )

  # 桌面环境相关配置目录
  DE_DIRS=(
    "dunst"
    "fontconfig"
    "hypr"
    "rofi"
    "waybar"
  )

  # 确保目标目录存在
  mkdir -p "$HOME/.config"

  # 根据安装类型选择要链接的目录
  local dirs_to_link=()

  if [ "$install_type" = "2" ]; then
    # 只链接终端相关配置
    log "Linking terminal-related configuration directories only..."
    dirs_to_link=("${TERMINAL_DIRS[@]}")
  else
    # 链接所有配置
    log "Linking all configuration directories..."
    dirs_to_link=("${TERMINAL_DIRS[@]}" "${DE_DIRS[@]}")
  fi

  # 创建配置目录的软链接
  for dir in "${dirs_to_link[@]}"; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
      create_symlink "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
    fi
  done

  # 特殊目录处理
  log "Creating symlinks for special directories..."

  # 常见配置文件
  log "Creating symlinks for configuration files..."

  # 配置文件列表示例 - 请根据实际dotfiles结构调整
  FILES=(
    "ssh/config"
    "zsh/.zshrc"
    "starship.toml"
    "code-flags.conf"
  )

  # 创建配置文件的软链接
  for file in "${FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
      # 直接根据文件类型决定目标位置
      case "$file" in

      "ssh/config")
        create_symlink "$DOTFILES_DIR/$file" "$HOME/.ssh/config"
        ;;
      # zsh特殊处理 - 直接链接到家目录
      "zsh/.zshrc")
        create_symlink "$DOTFILES_DIR/$file" "$HOME/.zshrc"
        ;;
      # 这些文件通常放在家目录
      .zshrc | .bashrc | .profile | .bash_profile)
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
        ;;
      # 这些应该放在XDG配置目录
      starship.toml | code-flags.conf)
        mkdir -p "$HOME/.config"
        create_symlink "$DOTFILES_DIR/$file" "$HOME/.config/$file"
        ;;
      # 其他文件，判断其是否应该以点开头
      *)
        if [[ "$file" == .* ]]; then
          create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
        else
          create_symlink "$DOTFILES_DIR/$file" "$HOME/.config/$file"
        fi
        ;;
      esac
    fi
  done

  success "Dotfiles symlinks created successfully"
}

# 主函数
main() {
  print_header

  # 创建备份目录
  mkdir -p "$BACKUP_DIR"
  log "Backup directory created at: $BACKUP_DIR"

  # 检查是否为Arch Linux
  if [ ! -f /etc/arch-release ]; then
    error "This script is only compatible with Arch Linux"
    exit 1
  fi

  # 检查并安装AUR助手
  check_install_aur_helper || {
    error "Failed to setup AUR helper"
    exit 1
  }

  # 安装软件包
  install_packages || { error "Package installation had issues"; }

  # 创建dotfiles软链接
  link_dotfiles || { error "Dotfiles linking had issues"; }

  echo ""
  echo -e "${GREEN}┌─────────────────────────────────────────────┐${NC}"
  echo -e "${GREEN}│            Installation Complete!           │${NC}"
  echo -e "${GREEN}└─────────────────────────────────────────────┘${NC}"
  echo ""
  echo -e "You may need to log out and log back in to apply all changes."
  echo -e "If you encounter any issues, check the backup at: $BACKUP_DIR"
}

# 执行主函数
main "$@"
