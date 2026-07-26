#!/bin/zsh
# Weekly report of large files (>100MB) on SSD

SEARCH_DIR="{{SSD_MOUNT}}"
THRESHOLD_MB=100
REPORT="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/large-files-$(date +%Y-%m-%d).txt"
mkdir -p "$(dirname $REPORT)"

echo "📦 Large File Report — $(date)" > "$REPORT"
echo "Files larger than ${THRESHOLD_MB}MB on SSD" >> "$REPORT"
echo "========================================" >> "$REPORT"

COUNT=0
TOTAL=0

while IFS= read -r line; do
  SIZE=$(echo "$line" | awk '{print $1}')
  FILE=$(echo "$line" | cut -f2-)
  SIZE_MB=$((SIZE / 1024))
  echo "  ${SIZE_MB}MB  →  $FILE" >> "$REPORT"
  TOTAL=$((TOTAL + SIZE_MB))
  COUNT=$((COUNT + 1))
done < <(find "$SEARCH_DIR" -type f \
  ! -path "*/.git/*" \
  ! -path "*/node_modules/*" \
  ! -path "*/.backups/*" \
  -size +${THRESHOLD_MB}M \
  -exec stat -f "%z %N" {} \; 2>/dev/null | sort -rn)

echo "\n========================================" >> "$REPORT"
echo "Total: $COUNT files, ~${TOTAL}MB" >> "$REPORT"

echo "✅ Found $COUNT files over ${THRESHOLD_MB}MB (~${TOTAL}MB total)"
echo "Report → $REPORT"
osascript -e "display notification \"$COUNT large files found (~${TOTAL}MB). Check report.\" with title \"📦 Large File Tracker\""
