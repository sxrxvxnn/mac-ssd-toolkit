#!/bin/zsh
# Tracks battery health + cycle count over time

LOG="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/battery-health-log.txt"
mkdir -p "$(dirname $LOG)"

DATE=$(date +"%Y-%m-%d %H:%M")

RAW=$(system_profiler SPPowerDataType 2>/dev/null)

CYCLE=$(echo "$RAW" | awk '/Cycle Count/ {print $3}')
HEALTH=$(echo "$RAW" | awk '/Maximum Capacity/ {print $3}')
CONDITION=$(echo "$RAW" | awk '/Condition/ {print $2}')
CHARGE=$(pmset -g batt | awk -F'[%]' 'NR==2 {print $1}' | awk '{print $NF}')

echo "$DATE | cycles=$CYCLE | health=$HEALTH | condition=$CONDITION | charge=${CHARGE}%" >> "$LOG"

echo "🔋 Battery Health"
echo "   Cycle Count : $CYCLE"
echo "   Max Capacity: $HEALTH"
echo "   Condition   : $CONDITION"
echo "   Current     : ${CHARGE}%"

# Warn if health below 80%
HEALTH_NUM=$(echo "$HEALTH" | tr -d '%')
if [ -n "$HEALTH_NUM" ] && [ "$HEALTH_NUM" -lt 80 ]; then
  osascript -e "display notification \"Battery health at ${HEALTH}. Consider replacing battery.\" with title \"⚠️ Battery Health Low\" sound name \"Basso\""
fi
