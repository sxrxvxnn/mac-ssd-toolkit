#!/bin/zsh
# Quick project switcher — opens project in VS Code + sets terminal

DEV_DIR="{{SSD_MOUNT}}/Dev"

PROJECTS=(
  leadgen-platform
  linkedin_automate
  lead-engine
  marvel-portfolio
  RESUME
)

if [ -z "$1" ]; then
  echo "📁 Available projects:"
  for i in "${!PROJECTS[@]}"; do
    echo "  $((i+1)). ${PROJECTS[$i]}"
  done
  echo ""
  echo "Usage: ./15-project-switcher.sh <name or number>"
  exit 0
fi

# Match by number or name
if [[ "$1" =~ ^[0-9]+$ ]]; then
  IDX=$((${1} - 1))
  PROJECT="${PROJECTS[$IDX]}"
else
  PROJECT="$1"
fi

PROJECT_PATH="$DEV_DIR/$PROJECT"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "❌ Project not found: $PROJECT"
  exit 1
fi

echo "🚀 Switching to $PROJECT..."

# Open in VS Code
code "$PROJECT_PATH" 2>/dev/null && echo "  ✓ Opened in VS Code"

# Set terminal title
echo -ne "\033]0;$PROJECT\007"

# Print path for easy cd
echo ""
echo "  cd $PROJECT_PATH"
echo ""
echo "✅ Ready — $PROJECT"
