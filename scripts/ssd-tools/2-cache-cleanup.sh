#!/bin/zsh
# Clears regeneratable caches to free internal Mac storage

echo "🧹 Starting cache cleanup..."

BEFORE=$(df -h / | tail -1 | awk '{print $4}')

# User caches (safe to delete — all regenerate)
CACHES=(
  "$HOME/Library/Caches"
  "$HOME/Library/Logs"
  "/Library/Caches"
)

FREED=0
for cache in "${CACHES[@]}"; do
  if [ -d "$cache" ]; then
    SIZE=$(du -sm "$cache" 2>/dev/null | awk '{print $1}')
    rm -rf "$cache"/* 2>/dev/null
    echo "  ✓ Cleared $cache (~${SIZE}MB)"
    FREED=$((FREED + SIZE))
  fi
done

# Xcode derived data if exists
if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
  SIZE=$(du -sm "$HOME/Library/Developer/Xcode/DerivedData" 2>/dev/null | awk '{print $1}')
  rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/*  2>/dev/null
  echo "  ✓ Cleared Xcode DerivedData (~${SIZE}MB)"
  FREED=$((FREED + SIZE))
fi

# npm cache
if command -v npm &>/dev/null; then
  npm cache clean --force 2>/dev/null
  echo "  ✓ Cleared npm cache"
fi

# pnpm cache
if command -v pnpm &>/dev/null; then
  pnpm store prune 2>/dev/null
  echo "  ✓ Pruned pnpm store"
fi

AFTER=$(df -h / | tail -1 | awk '{print $4}')
echo ""
echo "✅ Done. Free space: $BEFORE → $AFTER"
osascript -e "display notification \"Free space: $BEFORE → $AFTER\" with title \"✅ Cache Cleanup Done\""
