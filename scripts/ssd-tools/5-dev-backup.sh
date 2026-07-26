#!/bin/zsh
# Rsync active dev projects to a backup folder on SSD

SOURCE="{{SSD_MOUNT}}/Dev"
BACKUP="{{SSD_MOUNT}}/Dev/.backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_DIR="$BACKUP/$DATE"

# Projects to back up (active ones only — skip archives)
PROJECTS=(
  leadgen-platform
  linkedin_automate
  lead-engine
  marvel-portfolio
  RESUME
)

echo "📦 Starting backup → $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for project in "${PROJECTS[@]}"; do
  src="$SOURCE/$project"
  if [ -d "$src" ] || [ -L "$src" ]; then
    # Resolve symlink if needed
    real_src=$(realpath "$src" 2>/dev/null || echo "$src")
    echo "  Backing up $project..."
    rsync -a --delete \
      --exclude='.git' \
      --exclude='node_modules' \
      --exclude='.next' \
      --exclude='__pycache__' \
      --exclude='*.pyc' \
      --exclude='.venv' \
      --exclude='venv' \
      --exclude='.pytest_cache' \
      "$real_src/" "$BACKUP_DIR/$project/" 2>/dev/null
    echo "  ✓ $project"
  else
    echo "  ⚠️  $project not found, skipping"
  fi
done

# Backup toolchains (.rustup, .cargo, .nvm, .npm, .android, .m2, .gradle, .pub-cache)
echo ""
echo "🔧 Backing up toolchains..."
rsync -a --delete \
  --exclude='.pub-cache/_temp' \
  --exclude='.gradle/daemon' \
  --exclude='.gradle/caches/transforms*' \
  "$SOURCE/.toolchains/" "$BACKUP_DIR/.toolchains/" 2>/dev/null
echo "  ✓ .toolchains"

# Keep only last 7 backups
echo ""
echo "🗂  Pruning old backups (keeping last 7)..."
ls -dt "$BACKUP"/*/ 2>/dev/null | tail -n +8 | xargs rm -rf 2>/dev/null
echo "  ✓ Done"

BACKUP_SIZE=$(du -sh "$BACKUP_DIR" 2>/dev/null | awk '{print $1}')
echo ""
echo "✅ Backup complete → $BACKUP_DIR ($BACKUP_SIZE)"
osascript -e "display notification \"Backup saved to $DATE ($BACKUP_SIZE)\" with title \"✅ Dev Backup Done\""
