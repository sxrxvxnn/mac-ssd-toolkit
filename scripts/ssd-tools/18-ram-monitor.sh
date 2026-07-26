#!/bin/zsh
# Alerts on critical RAM pressure, auto-kills heaviest process

THRESHOLD_PCT=90

# Get memory stats
TOTAL=$(sysctl -n hw.memsize)
TOTAL_MB=$((TOTAL / 1048576))

VM=$(vm_stat)
PAGE=4096

WIRED=$(echo "$VM" | awk '/wired/ {gsub(/\./, "", $4); print $4}')
ACTIVE=$(echo "$VM" | awk '/Pages active/ {gsub(/\./, "", $3); print $3}')
COMPRESSED=$(echo "$VM" | awk '/occupied by compressor/ {gsub(/\./, "", $5); print $5}')

USED_MB=$(( (WIRED + ACTIVE + COMPRESSED) * PAGE / 1048576 ))
PCT=$(( USED_MB * 100 / TOTAL_MB ))

echo "🧠 RAM: ${USED_MB}MB / ${TOTAL_MB}MB (${PCT}%)"

if [ "$PCT" -gt "$THRESHOLD_PCT" ]; then
  # Find heaviest non-system process
  HEAVY=$(ps aux | sort -rk4 | grep -v "root\|_\|com.apple" | awk 'NR==2 {print $2, $11}')
  HEAVY_PID=$(echo $HEAVY | awk '{print $1}')
  HEAVY_NAME=$(echo $HEAVY | awk '{print $2}')

  osascript -e "display notification \"RAM at ${PCT}%. Killing $HEAVY_NAME to free memory.\" with title \"⚠️ RAM Critical\" sound name \"Basso\""
  kill "$HEAVY_PID" 2>/dev/null
  echo "❌ Killed $HEAVY_NAME (PID $HEAVY_PID)"
else
  echo "✅ RAM OK (${PCT}%)"
fi
