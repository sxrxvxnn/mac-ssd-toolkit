#!/bin/zsh
# Monitors SSD free space and predicts fill date

SSD="{{SSD_MOUNT}}"
LOG="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/ssd-health-log.txt"
mkdir -p "$(dirname $LOG)"

FREE_BYTES=$(df "$SSD" | tail -1 | awk '{print $4}')
USED_BYTES=$(df "$SSD" | tail -1 | awk '{print $3}')
TOTAL_BYTES=$(df "$SSD" | tail -1 | awk '{print $2}')

FREE_GB=$(echo "scale=1; $FREE_BYTES / 1048576" | bc)
USED_GB=$(echo "scale=1; $USED_BYTES / 1048576" | bc)
TOTAL_GB=$(echo "scale=1; $TOTAL_BYTES / 1048576" | bc)
PCT=$(echo "scale=1; $USED_BYTES * 100 / $TOTAL_BYTES" | bc)

DATE=$(date +"%Y-%m-%d %H:%M")
echo "$DATE | used=${USED_GB}GB free=${FREE_GB}GB pct=${PCT}%" >> "$LOG"

# Predict fill date using last 7 log entries
LINES=$(wc -l < "$LOG")
PREDICTION=""
if [ "$LINES" -ge 7 ]; then
  OLDEST=$(tail -7 "$LOG" | head -1 | awk -F'used=' '{print $2}' | awk -F'GB' '{print $1}')
  NEWEST=$(tail -1 "$LOG" | awk -F'used=' '{print $2}' | awk -F'GB' '{print $1}')
  DIFF=$(echo "scale=2; $NEWEST - $OLDEST" | bc)
  DAYS_SPAN=7

  if (( $(echo "$DIFF > 0" | bc -l) )); then
    DAILY_RATE=$(echo "scale=2; $DIFF / $DAYS_SPAN" | bc)
    DAYS_LEFT=$(echo "scale=0; $FREE_GB / $DAILY_RATE" | bc)
    PREDICTION="At current rate, SSD full in ~${DAYS_LEFT} days"
  else
    PREDICTION="Usage stable or decreasing"
  fi
fi

echo "💾 SSD Health Report"
echo "   Used  : ${USED_GB}GB / ${TOTAL_GB}GB (${PCT}%)"
echo "   Free  : ${FREE_GB}GB"
echo "   $PREDICTION"

if (( $(echo "$PCT > 85" | bc -l) )); then
  osascript -e "display notification \"SSD ${PCT}% full (${FREE_GB}GB left). $PREDICTION\" with title \"⚠️ SSD Almost Full\" sound name \"Basso\""
else
  osascript -e "display notification \"SSD ${PCT}% used. ${FREE_GB}GB free. $PREDICTION\" with title \"💾 SSD Health\""
fi
