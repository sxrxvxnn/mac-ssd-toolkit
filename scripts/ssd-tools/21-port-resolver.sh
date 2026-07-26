#!/bin/zsh
# Scans ports 3000-3010, shows what's running, optional kill

echo "🔌 Port Scanner (3000–3010)"
echo "================================="

FOUND=0
for port in $(seq 3000 3010); do
  PID=$(lsof -ti:$port 2>/dev/null)
  if [ -n "$PID" ]; then
    NAME=$(ps -p $PID -o comm= 2>/dev/null | xargs basename)
    CMD=$(ps -p $PID -o args= 2>/dev/null | cut -c1-60)
    echo "  :$port  →  $NAME (PID $PID)"
    echo "         $CMD"
    FOUND=$((FOUND + 1))
  fi
done

if [ "$FOUND" -eq 0 ]; then
  echo "  All ports free"
  exit 0
fi

echo ""
if [[ "$1" == "--kill" ]]; then
  echo "Killing all processes on ports 3000-3010..."
  for port in $(seq 3000 3010); do
    PID=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$PID" ]; then
      NAME=$(ps -p $PID -o comm= 2>/dev/null | xargs basename)
      kill "$PID" 2>/dev/null && echo "  ✓ Killed $NAME on :$port"
    fi
  done
else
  echo "Run with --kill to terminate all"
fi
