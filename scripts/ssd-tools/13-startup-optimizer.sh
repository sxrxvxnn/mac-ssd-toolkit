#!/bin/zsh
# Kills memory-heavy background processes on login

echo "🚀 Startup Optimizer running..."

# Processes to kill if running (background/helper processes)
KILL_LIST=(
  "com.apple.photoanalysisd"    # Photos background analysis — CPU hog
  "com.apple.mediaanalysisd"    # Media analysis daemon
  "com.apple.suggestd"          # Siri suggestions indexing
  "com.apple.spotlightknowledge" # Spotlight ML indexing
  "mds_stores"                  # Spotlight indexing (restarts itself — just throttles)
)

KILLED=0
for proc in "${KILL_LIST[@]}"; do
  PID=$(pgrep -f "$proc" 2>/dev/null)
  if [ -n "$PID" ]; then
    kill "$PID" 2>/dev/null && echo "  ✓ Killed $proc" && KILLED=$((KILLED + 1))
  fi
done

# Free memory pressure
sudo purge 2>/dev/null && echo "  ✓ Memory purged"

# Check RAM usage
FREE_MEM=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
FREE_MB=$((FREE_MEM * 4096 / 1048576))

echo ""
echo "✅ Done — killed $KILLED background processes"
echo "   Free RAM: ~${FREE_MB}MB"
osascript -e "display notification \"Killed $KILLED background processes. ${FREE_MB}MB RAM free.\" with title \"🚀 Startup Optimized\""
