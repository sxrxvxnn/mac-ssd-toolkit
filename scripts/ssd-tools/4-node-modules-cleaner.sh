#!/bin/zsh
# Finds and removes node_modules not touched in 30+ days

SEARCH_DIR="{{SSD_MOUNT}}/Dev"
DAYS_OLD=30
DRY_RUN=false

# Pass --dry-run to preview without deleting
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 DRY RUN — nothing will be deleted"
fi

echo "Scanning $SEARCH_DIR for node_modules older than ${DAYS_OLD} days..."
echo ""

TOTAL_MB=0
COUNT=0

while IFS= read -r dir; do
  SIZE_MB=$(du -sm "$dir" 2>/dev/null | awk '{print $1}')
  LAST_MOD=$(stat -f "%Sm" -t "%Y-%m-%d" "$dir" 2>/dev/null)
  PARENT=$(dirname "$dir")

  echo "  📦 $PARENT"
  echo "     Size: ${SIZE_MB}MB  |  Last modified: $LAST_MOD"

  if [ "$DRY_RUN" = false ]; then
    rm -rf "$dir"
    echo "     ✓ Deleted"
  fi

  TOTAL_MB=$((TOTAL_MB + SIZE_MB))
  COUNT=$((COUNT + 1))
done < <(find "$SEARCH_DIR" -name "node_modules" -type d -prune -mtime +$DAYS_OLD 2>/dev/null)

echo ""
if [ "$COUNT" -eq 0 ]; then
  echo "✅ No stale node_modules found"
else
  if [ "$DRY_RUN" = true ]; then
    echo "🔍 Would free ~${TOTAL_MB}MB from $COUNT node_modules folders"
  else
    echo "✅ Freed ~${TOTAL_MB}MB from $COUNT node_modules folders"
    osascript -e "display notification \"Freed ~${TOTAL_MB}MB from $COUNT node_modules\" with title \"✅ node_modules Cleaned\""
  fi
fi
