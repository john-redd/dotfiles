#!/usr/bin/env bash

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
  # MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar primary &
  MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar main -c ~/.config/polybar/gruvbox/config.ini &
else
  primary=$(xrandr --query | grep primary | cut -d" " -f1)

  for m in $screens; do
    if [[ $primary == $m ]]; then
        # MONITOR=$m TRAY_POS=right polybar primary &
        MONITOR=$m TRAY_POS=right polybar main -c ~/.config/polybar/gruvbox/config.ini & 
    else
        # MONITOR=$m TRAY_POS=none polybar secondary &
        MONITOR=$m TRAY_POS=none polybar main -c ~/.config/polybar/gruvbox/config.ini & 
    fi
  done
fi
