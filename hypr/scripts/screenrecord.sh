#!/usr/bin/env bash

SIGNAL=1
pidf="/tmp/waybar-screenrecorder"
WF_RECORDER_OPTS=""
# Insert `--audio` if you want to record audio
# Specify video codec
# find available video codecs with `ffmpeg -encoders`
WF_RECORDER_OPTS="$WF_RECORDER_OPTS -c h264_vaapi  -d /dev/dri/renderD128"
# Specify audio codec
# find available audio codecs with `ffmpeg -codecs`
# WF_RECORDER_OPTS="$WF_RECORDER_OPTS --audio --codec opus"
# printf "WF_RECORDER_OPTS=%s\n" "$WF_RECORDER_OPTS"
VIDEOEXT="mkv"

if [ "$1" == "status" ]; then
  if [ -s "$pidf" ]; then
    awk 'BEGIN{printf "{\"text\":\"\", \"tooltip\":\"Recording\\n"}
		NR==1{printf "PID: %s\\n", $0}
		NR==2{printf "Save to: %s\\n", $0}
		NR==3{printf "Log to: %s\"}\n", $0}' "$pidf"
  else
    printf '{"text":"", "tooltip":"Stopped"}\n'
  fi

elif [ "$1" == "toggle" ]; then
  if [ -s "$pidf" ]; then
    pid=$(awk 'NR==1' "$pidf")
    kill "$pid"
    printf "" >"$pidf"
  else
    mkdir -p "$HOME/Videos/screencasts"
    bf="$HOME/Videos/screencasts/$(date +'%Y%m%dT%H%M%S')"
    vidf="$bf.$VIDEOEXT"
    logf="$bf.log"
    if [ "$2" == "fullscreen" ]; then
      wf-recorder $WF_RECORDER_OPTS --file "$vidf" 1>"$logf" 2>&1 &
    elif [ "$2" == "region" ]; then
      sleep 1
      wf-recorder $WF_RECORDER_OPTS --geometry "$(slurp)" --file "$vidf" 1>"$logf" 2>&1 &
    else
      printf "argument \$2='%s' not valid (fullscreen/region)" "$2"
      exit
    fi
    pid=$(jobs -p | tail -n 1)
    printf "%d\n%s\n%s" "$pid" "$vidf" "$logf" >"$pidf"
    disown "$pid"
  fi
  pkill -RTMIN+$SIGNAL waybar

else
  printf "ERROR: argument %s not valid\n" "$1"
fi
