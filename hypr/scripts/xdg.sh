#!/usr/bin/env bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|
#

sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gnome
killall xdg-desktop-portal-kde
killall xdg-desktop-portal-lxqt
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
sleep 1

# Use different directory on NixOS
if [ -d /run/current-system/sw/libexec ]; then
  libDir=/run/current-system/sw/libexec
else
  libDir=/usr/lib
fi

$libDir/xdg-desktop-portal-hyprland &
sleep 2
$libDir/xdg-desktop-portal &
