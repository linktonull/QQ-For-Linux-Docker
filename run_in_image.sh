#!/bin/bash
export HOME=/home/user
export XDG_CONFIG_HOME="$HOME/.config"
notify-send "如果你能看到这句话，那 D-Bus 应该配置好了"

if [[ -f "${XDG_CONFIG_HOME}/qq-flags.conf" ]]; then
  echo "Reading user defined flags from ${XDG_CONFIG_HOME}/qq-flags.conf..."
  readarray -t FLAGS < "${XDG_CONFIG_HOME}/qq-flags.conf"
  /opt/QQ/qq "${FLAGS[@]}" "$@"
else
  /opt/QQ/qq --ozone-platform=x11
fi