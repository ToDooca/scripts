#!/usr/bin/env sh

_bc() {
	echo "scale=${2:-"2"}; $1" | bc
}

case $BLOCK_BUTTON in
    1) notify-send -i modem "Public IP" "$(curl -s api.ipify.org)" ;;
    3) notify-send -i network-wired "Local IP" "$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)" ;;
esac

IFACE="$(ip link | grep -e "BROADCAST" | sed 1q | awk '{print $2}' | cut -d ':' -f1)"

SLEEP=1

OUT_FORMAT=" %5s 祝%5s"

while getopts ":f:" ARG; do
	case $ARG in
		f) OUT_FORMAT="$OPTARG" ;;
		:) echo "bandwidth: -$OPTARG requires an argument"
			exit 2 ;;
	esac
done

shift $((OPTIND - 1))


RX_OLD="$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes)"
TX_OLD="$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes)"

TIME_START=$(echo '('`date +"%s.%N"` ' * 1000000)/1' | bc)

sleep $SLEEP

RX_NEW="$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes)"
TX_NEW="$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes)"

TIME_END=$(echo '('`date +"%s.%N"` ' * 1000000)/1' | bc)

RX_DELTA=$((RX_NEW - RX_OLD))
TX_DELTA=$((TX_NEW - TX_OLD))


TIME_DELTA="$(_bc "$((TIME_END - TIME_START)) / 1000000")"

FORMAT="%4f"
RX_OUT="$(_bc "$RX_DELTA / $TIME_DELTA" 0)"
RX_OUT="$(numfmt --to iec --format "$FORMAT" $RX_OUT)"

TX_OUT="$(_bc "$TX_DELTA / $TIME_DELTA" 0)"
TX_OUT="$(numfmt --to iec --format "$FORMAT" $TX_OUT)"


printf "$OUT_FORMAT" "$RX_OUT" "$TX_OUT"
echo
