#!/bin/zsh
# Live terminal dashboard of SSD folder sizes

SSD="{{SSD_MOUNT}}"

clear
echo "╔══════════════════════════════════════════╗"
echo "║           SSD DASHBOARD — 007            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# SSD overall
FREE=$(df -h "$SSD" | tail -1 | awk '{print $4}')
USED=$(df -h "$SSD" | tail -1 | awk '{print $3}')
TOTAL=$(df -h "$SSD" | tail -1 | awk '{print $2}')
PCT=$(df "$SSD" | tail -1 | awk '{print $5}')

echo "  💾 Total: $TOTAL   Used: $USED   Free: $FREE  ($PCT)"
echo ""
echo "  ── TOP FOLDERS ─────────────────────────"

du -sh "$SSD"/*/ 2>/dev/null | sort -rh | while read size dir; do
  name=$(basename "$dir")
  BAR_LEN=$(du -sm "$dir" 2>/dev/null | awk '{printf "%d", $1/1024*20}')
  BAR=$(printf '%0.s█' $(seq 1 $((BAR_LEN > 0 ? BAR_LEN : 1))))
  printf "  %-18s %6s  %s\n" "$name" "$size" "$BAR"
done

echo ""
echo "  ── DEV PROJECTS ─────────────────────────"
du -sh "$SSD/Dev"/*/  2>/dev/null | sort -rh | head -10 | while read size dir; do
  name=$(basename "$dir")
  printf "  %-25s %s\n" "$name" "$size"
done

echo ""
echo "  Last updated: $(date '+%H:%M:%S')"
echo "  Press Ctrl+C to exit  |  Run again to refresh"
