#!/usr/bin/env bash

# Configuration
WAYBAR_DIR="$HOME/.config/waybar"
THEMES_DIR="$WAYBAR_DIR/themes"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Validate environment
[ ! -d "$THEMES_DIR" ] && exit 1
THEMES=($(ls -1 "$THEMES_DIR" | sort))
[ ${#THEMES[@]} -eq 0 ] && exit 1

# Get current theme
CURRENT=""
if [ -L "$WAYBAR_DIR/config.jsonc" ]; then
  LINK_TARGET=$(readlink "$WAYBAR_DIR/config.jsonc")
  CURRENT=$(basename $(dirname "$LINK_TARGET"))
fi

# Find next theme
next_idx=0
if [ -n "$CURRENT" ]; then
  for ((i = 0; i < ${#THEMES[@]}; i++)); do
    if [ "$CURRENT" = "${THEMES[$i]}" ]; then
      next_idx=$(((i + 1) % ${#THEMES[@]}))
      break
    fi
  done
fi
NEXT_THEME="${THEMES[$next_idx]}"

# Apply theme
cd "$WAYBAR_DIR"
ln -sf "themes/$NEXT_THEME/config.jsonc" config.jsonc
ln -sf "themes/$NEXT_THEME/style.css" style.css

# Change hyprland settings
update_hyprland_var() {
  local var_name="$1"
  local var_value="$2"
  sed -i "s/^\$$var_name = .*$/\$$var_name = $var_value/" "$HYPR_CONF"
}

case "$NEXT_THEME" in
"style-1")
  update_hyprland_var "rounding" "4"
  update_hyprland_var "gaps_in" "5"
  update_hyprland_var "gaps_out" "5,10"
  ;;
"style-2")
  update_hyprland_var "rounding" "0"
  update_hyprland_var "gaps_in" "2"
  update_hyprland_var "gaps_out" "4"
  ;;
"style-3")
  update_hyprland_var "rounding" "4"
  update_hyprland_var "gaps_in" "3"
  update_hyprland_var "gaps_out" "3,5,3,5"
  ;;
"style-4")
  update_hyprland_var "rounding" "8"
  update_hyprland_var "gaps_in" "5"
  update_hyprland_var "gaps_out" "5,8"
  ;;
esac

pkill -x waybar
sleep 0.1

# Try uwsm first, fallback to direct launch
if command -v uwsm; then
  uwsm app -- waybar &
  disown
else
  waybar &>/dev/null &
  disown
fi
