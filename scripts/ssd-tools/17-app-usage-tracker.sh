#!/bin/zsh
# Logs active app every 5 minutes, generates daily usage report

LOG_DIR="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/app-usage"
mkdir -p "$LOG_DIR"

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M")
LOG="$LOG_DIR/$DATE.log"

# Get frontmost app
ACTIVE_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

echo "$TIME | $ACTIVE_APP" >> "$LOG"

# Generate report if called with --report
if [[ "$1" == "--report" ]]; then
  echo "📊 App Usage Report — $DATE"
  echo "==============================="
  sort "$LOG" | awk -F' | ' '{print $2}' | sort | uniq -c | sort -rn | while read count app; do
    MINS=$((count * 5))
    echo "  ${MINS}min  —  $app"
  done
fi
