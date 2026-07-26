#!/bin/zsh
# Weekly npm audit across all projects — notifies if vulnerabilities found

DEV_DIR="{{SSD_MOUNT}}/Dev"
REPORT="{{SSD_MOUNT}}/Dev/scripts/ssd-tools/reports/dep-audit-$(date +%Y-%m-%d).txt"
mkdir -p "$(dirname $REPORT)"

echo "🔐 Dependency Audit — $(date)" > "$REPORT"
echo "========================================" >> "$REPORT"

TOTAL_VULN=0
PROJECTS_AFFECTED=0

for dir in "$DEV_DIR"/*/; do
  pkg="$dir/package.json"
  if [ -f "$pkg" ] && [ -d "$dir/node_modules" ]; then
    name=$(basename "$dir")
    cd "$dir"
    echo "\n📁 $name" >> "$REPORT"

    result=$(npm audit --json 2>/dev/null)
    vuln=$(echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('metadata',{}).get('vulnerabilities',{}).get('total',0))" 2>/dev/null || echo "0")

    if [ "$vuln" -gt 0 ]; then
      echo "   ⚠️  $vuln vulnerabilities found" >> "$REPORT"
      npm audit 2>/dev/null | grep -E "high|critical|moderate" | head -5 | sed 's/^/   /' >> "$REPORT"
      TOTAL_VULN=$((TOTAL_VULN + vuln))
      PROJECTS_AFFECTED=$((PROJECTS_AFFECTED + 1))
    else
      echo "   ✅ No vulnerabilities" >> "$REPORT"
    fi
  fi
done

echo "\n========================================" >> "$REPORT"
echo "Total vulnerabilities: $TOTAL_VULN across $PROJECTS_AFFECTED projects" >> "$REPORT"

echo "✅ Audit complete — $TOTAL_VULN vulnerabilities in $PROJECTS_AFFECTED projects"
echo "Report → $REPORT"

if [ "$TOTAL_VULN" -gt 0 ]; then
  osascript -e "display notification \"$TOTAL_VULN vulnerabilities in $PROJECTS_AFFECTED projects. Run npm audit fix.\" with title \"⚠️ Dependency Audit\" sound name \"Basso\""
else
  osascript -e "display notification \"All projects clean.\" with title \"✅ Dependency Audit\""
fi
