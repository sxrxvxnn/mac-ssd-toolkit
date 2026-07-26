#!/bin/zsh
# Daily summary of uncommitted changes across all Dev projects

DEV_DIR="{{SSD_MOUNT}}/Dev"
REPORT="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/git-status-$(date +%Y-%m-%d).txt"
mkdir -p "$(dirname $REPORT)"

echo "📋 Git Status Report — $(date)" > "$REPORT"
echo "========================================" >> "$REPORT"

DIRTY=0
CLEAN=0
AHEAD=0

for dir in "$DEV_DIR"/*/; do
  if [ -d "$dir/.git" ]; then
    name=$(basename "$dir")
    cd "$dir"

    uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    branch=$(git branch --show-current 2>/dev/null)
    ahead=$(git log @{upstream}.. --oneline 2>/dev/null | wc -l | tr -d ' ')
    last_commit=$(git log -1 --format="%ar" 2>/dev/null)

    echo "\n📁 $name ($branch)" >> "$REPORT"
    echo "   Last commit  : $last_commit" >> "$REPORT"

    if [ "$uncommitted" -gt 0 ]; then
      echo "   ⚠️  Uncommitted: $uncommitted file(s)" >> "$REPORT"
      git status --short 2>/dev/null | head -5 | sed 's/^/      /' >> "$REPORT"
      DIRTY=$((DIRTY + 1))
    else
      echo "   ✅ Clean" >> "$REPORT"
      CLEAN=$((CLEAN + 1))
    fi

    if [ "$ahead" -gt 0 ]; then
      echo "   🚀 Unpushed  : $ahead commit(s)" >> "$REPORT"
      AHEAD=$((AHEAD + 1))
    fi
  fi
done

echo "\n========================================" >> "$REPORT"
echo "Clean: $CLEAN  |  Dirty: $DIRTY  |  Unpushed: $AHEAD" >> "$REPORT"

cat "$REPORT"
osascript -e "display notification \"$DIRTY dirty, $AHEAD unpushed repos. Check report.\" with title \"📋 Git Status Report\""
