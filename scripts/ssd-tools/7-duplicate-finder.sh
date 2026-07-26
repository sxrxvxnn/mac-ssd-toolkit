#!/bin/zsh
# Finds duplicate files on SSD by MD5 hash

SEARCH_DIR="{{SSD_MOUNT}}"
REPORT="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/duplicates-$(date +%Y-%m-%d).txt"
mkdir -p "$(dirname $REPORT)"

echo "🔍 Scanning for duplicates in $SEARCH_DIR..."
echo "Duplicate File Report — $(date)" > "$REPORT"
echo "========================================" >> "$REPORT"

TOTAL_WASTE=0
DUPE_COUNT=0

# Build hash map
declare -A seen
declare -A seen_path

while IFS= read -r file; do
  hash=$(md5 -q "$file" 2>/dev/null)
  size=$(stat -f%z "$file" 2>/dev/null)

  if [[ -n "${seen[$hash]}" ]]; then
    echo "\n🔁 DUPLICATE ($((size/1024))KB):" >> "$REPORT"
    echo "   Original : ${seen_path[$hash]}" >> "$REPORT"
    echo "   Duplicate: $file" >> "$REPORT"
    TOTAL_WASTE=$((TOTAL_WASTE + size))
    DUPE_COUNT=$((DUPE_COUNT + 1))
  else
    seen[$hash]=1
    seen_path[$hash]="$file"
  fi
done < <(find "$SEARCH_DIR" -type f \
  ! -path "*/.git/*" \
  ! -path "*/.backups/*" \
  ! -path "*/node_modules/*" \
  ! -name ".DS_Store" \
  -size +100k 2>/dev/null)

WASTE_MB=$((TOTAL_WASTE / 1048576))
echo "\n========================================" >> "$REPORT"
echo "Total duplicates: $DUPE_COUNT" >> "$REPORT"
echo "Reclaimable space: ~${WASTE_MB}MB" >> "$REPORT"

echo "✅ Found $DUPE_COUNT duplicates (~${WASTE_MB}MB wasted)"
echo "Report saved → $REPORT"
osascript -e "display notification \"Found $DUPE_COUNT duplicates (~${WASTE_MB}MB). Check report.\" with title \"🔁 Duplicate Finder\""
