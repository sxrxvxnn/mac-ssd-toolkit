#!/bin/zsh
# Creates a dated dev log file in each active project

PROJECTS=(
  "{{SSD_MOUNT}}/Dev/leadgen-platform"
  "{{SSD_MOUNT}}/Dev/linkedin_automate"
  "{{SSD_MOUNT}}/Dev/lead-engine"
  "{{SSD_MOUNT}}/Dev/marvel-portfolio"
)

DATE=$(date +"%Y-%m-%d")
DAY=$(date +"%A, %B %d %Y")

for project in "${PROJECTS[@]}"; do
  if [ -d "$project" ]; then
    name=$(basename "$project")
    LOG_DIR="$project/.dev-logs"
    LOG_FILE="$LOG_DIR/$DATE.md"
    mkdir -p "$LOG_DIR"

    if [ ! -f "$LOG_FILE" ]; then
      cat > "$LOG_FILE" << EOF
# $name — $DAY

## What I'm working on


## Blockers


## Notes


## Done today

EOF
      echo "✓ Created log → $LOG_FILE"
    else
      echo "  ↩ Log exists for $name ($DATE)"
    fi
  fi
done

echo ""
echo "✅ Dev logs ready for $DATE"
osascript -e "display notification \"Dev logs created for $DATE\" with title \"📝 Daily Dev Log\""
