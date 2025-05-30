#!/usr/bin/env bash

# Current Theme
main_dir="$HOME/.config/rofi"
dir="$main_dir/themes"

# CMDs
uptime="$(awk '{printf "%d hour, %d minutes\n", $1/3600, ($1%3600)/60}' /proc/uptime)"
host=$(uname -a | awk '{print $2}')

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''
# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "Goodbye ${USER}" \
    -mesg "Uptime: $uptime" \
    -theme ${dir}/powermenu.rasi
}

# Confirmation CMD
confirm_cmd() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 2; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme ${dir}/powermenu.rasi
}

# Ask for confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$shutdown\n$reboot\n$lock\n$logout\n$suspend" | rofi_cmd
}

# Execute Command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff --now
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot --now
    elif [[ $1 == '--lock' ]]; then
      hyprlock
    elif [[ $1 == '--logout' ]]; then
      hyprctl dispatch exit 0
    elif [[ $1 == '--suspend' ]]; then
      systemctl suspend
    fi
  else
    exit 0
  fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
  run_cmd --shutdown
  ;;
$reboot)
  run_cmd --reboot
  ;;
$lock)
  if [[ -x '/usr/bin/betterlockscreen' ]]; then
    betterlockscreen -l
  elif [[ -x '/usr/bin/hyprlock' ]]; then
    run_cmd --lock
  elif [[ -x '/usr/bin/swaylock' ]]; then
    swaylock
  fi
  ;;
$suspend)
  run_cmd --suspend
  ;;
$logout)
  run_cmd --logout
  ;;
esac
