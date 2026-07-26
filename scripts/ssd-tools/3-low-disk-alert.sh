#!/bin/zsh
# Alerts when internal Mac storage drops below threshold

THRESHOLD_GB=10  # alert when free space below this

FREE_BYTES=$(df / | tail -1 | awk '{print $4}')
FREE_GB=$(echo "scale=1; $FREE_BYTES / 1048576" | bc)
FREE_ROUNDED=$(echo "$FREE_GB" | awk '{printf "%d", $1}')

SSD_FREE_BYTES=$(df {{SSD_MOUNT}} 2>/dev/null | tail -1 | awk '{print $4}')
SSD_FREE_GB=$(echo "scale=1; $SSD_FREE_BYTES / 1048576" | bc)

echo "Internal free: ${FREE_GB}GB"
echo "SSD free:      ${SSD_FREE_GB}GB"

if [ "$FREE_ROUNDED" -lt "$THRESHOLD_GB" ]; then
  osascript -e "display notification \"Only ${FREE_GB}GB left on Mac internal. Run cache cleanup or move files to SSD.\" with title \"⚠️ Low Disk Space\" sound name \"Basso\""
  echo "❌ WARNING: Internal storage low (${FREE_GB}GB free)"
else
  echo "✅ Internal storage OK (${FREE_GB}GB free)"
fi
