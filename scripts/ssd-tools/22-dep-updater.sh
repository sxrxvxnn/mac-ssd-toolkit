#!/bin/zsh
# Weekly npm update across all projects with node_modules, commits changes

DEV_DIR="{{SSD_MOUNT}}/Dev"
PROJECTS=(leadgen-platform linkedin_automate lead-engine marvel-portfolio)

echo "📦 Dependency Updater — $(date +%Y-%m-%d)"

for project in "${PROJECTS[@]}"; do
  dir="$DEV_DIR/$project"
  if [ -d "$dir/node_modules" ] && [ -f "$dir/package.json" ]; then
    echo "\n📁 $project"
    cd "$dir"

    # Check for updates
    OUTDATED=$(npm outdated --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d))" 2>/dev/null || echo "0")

    if [ "$OUTDATED" -gt 0 ]; then
      echo "  $OUTDATED packages outdated — updating..."
      npm update 2>/dev/null

      # Commit if package-lock changed
      if git diff --quiet package-lock.json 2>/dev/null; then
        echo "  ↩ No lock file changes"
      else
        git add package.json package-lock.json 2>/dev/null
        git commit -m "chore: weekly dependency update $(date +%Y-%m-%d)" 2>/dev/null
        echo "  ✓ Committed updates"
      fi
    else
      echo "  ✅ All up to date"
    fi
  fi
done

echo "\n✅ Dependency update complete"
osascript -e "display notification \"Dependency update complete\" with title \"📦 Deps Updated\""
