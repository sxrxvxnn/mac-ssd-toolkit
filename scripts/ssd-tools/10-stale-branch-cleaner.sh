#!/bin/zsh
# Finds and deletes merged/stale git branches across all projects

DEV_DIR="{{SSD_MOUNT}}/Dev"
DRY_RUN=false
DAYS_OLD=30

[[ "$1" == "--dry-run" ]] && DRY_RUN=true && echo "🔍 DRY RUN — nothing will be deleted"

echo "🌿 Stale Branch Cleaner — $(date)"
echo ""

TOTAL_DELETED=0

for dir in "$DEV_DIR"/*/; do
  if [ -d "$dir/.git" ]; then
    name=$(basename "$dir")
    cd "$dir"

    # Get merged branches (excluding main/master/current)
    current=$(git branch --show-current 2>/dev/null)
    merged=$(git branch --merged 2>/dev/null | grep -vE "^\*|main|master|develop|dev" | tr -d ' ')

    if [ -n "$merged" ]; then
      echo "📁 $name"
      while IFS= read -r branch; do
        last=$(git log -1 --format="%ar" "$branch" 2>/dev/null)
        echo "   🗑  $branch (last commit: $last)"
        if [ "$DRY_RUN" = false ]; then
          git branch -d "$branch" 2>/dev/null && TOTAL_DELETED=$((TOTAL_DELETED + 1))
        fi
      done <<< "$merged"
    fi
  fi
done

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "🔍 Dry run complete"
else
  echo "✅ Deleted $TOTAL_DELETED stale branches"
  osascript -e "display notification \"Deleted $TOTAL_DELETED stale branches\" with title \"🌿 Branch Cleaner Done\""
fi
