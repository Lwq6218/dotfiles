#!/usr/bin/env bash

#// set variables

rofi_config="$HOME/.config/rofi/themes/launcher.rasi"
rofi_args=(
  -show-icons
)
#// rofi action

case "${1}" in
d | --drun)
  r_mode="drun"
  rofi_args+=("--run-command" "sh -c 'uwsm app -- {cmd} || {cmd}'")
  ;;
w | --window)
  r_mode="window"
  ;;
f | --filebrowser)
  r_mode="filebrowser"
  ;;
r | --run)
  r_mode="run"
  rofi_args+=("--run-command" "sh -c 'uwsm app -- {cmd} || {cmd}'")
  ;;
h | --help)
  echo -e "$(basename "${0}") [action]"
  echo "d :  drun mode"
  echo "w :  window mode"
  echo "f :  filebrowser mode,"
  echo "r :  run mode"
  exit 0
  ;;
*)
  r_mode="drun"
  ROFI_LAUNCH_DRUN_STYLE="${ROFI_LAUNCH_DRUN_STYLE:-$ROFI_LAUNCH_STYLE}"
  ;;
esac

rofi_args+=(
  -theme "${rofi_config}"
)

#// launch rofi
rofi -show "${r_mode}" "${rofi_args[@]}" &
disown

rofi -show "${r_mode}" \
  -show-icons \
  -config "${rofi_config}" \
  -theme "${rofi_config}" \
  -dump-theme
