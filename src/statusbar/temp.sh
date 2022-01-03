#!/usr/bin/env sh

[ -e "$HOME/.config/colors.sh" ] && . "$HOME/.config/colors.sh" 

case $BLOCK_BUTTON in
	1) notify-send "CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)" ;;
esac

temp="$(sensors 2>/dev/null | awk '/Package id 0:/{print substr($4, 2)} /Tdie|Tctl/{print substr($2, 2)}' | head -n 1)"
temp_val="$(echo $temp | awk '{print substr($0, 1, length($0)-4)}')"
gpu_temp="$(sensors 2>/dev/null | awk '/edge:/ {print $2}')"
gpu_temp_val="$(echo $gpu_temp | awk '{print substr($0, 1, length($0)-4)}')"

gpu_color="$color7"
if [ "$gpu_temp_val" -ge 85 ]; then
	gpu_color="$theme11"
elif [ "$gpu_temp_val" -ge 70 ]; then
	gpu_color="$theme12"
elif [ "$gpu_temp_val" -ge 55 ]; then
	gpu_color="$theme13"
fi

color="$color7"
if [ "$temp_val" -ge 60 ]; then
	color="$theme11"
elif [ "$temp_val" -ge 50 ]; then
	color="$theme12"
elif [ "$temp_val" -ge 40 ]; then
	color="$theme13"
fi

printf "CPU: <span color=\"%s\">%s</span> GPU: <span color=\"%s\">%s</span>\n" $color $temp $gpu_color $gpu_temp
