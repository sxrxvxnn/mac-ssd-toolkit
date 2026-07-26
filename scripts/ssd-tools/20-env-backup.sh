#!/bin/zsh
# Backs up all .env files from dev projects to encrypted folder on SSD

DEV_DIR="{{SSD_MOUNT}}/Dev"
BACKUP_DIR="{{SSD_MOUNT}}/Dev/.env-backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "🔐 Backing up .env files..."

COUNT=0
while IFS= read -r envfile; do
  # Preserve project structure in backup
  REL=$(echo "$envfile" | sed "s|$DEV_DIR/||")
  DEST="$BACKUP_DIR/$(echo $REL | tr '/' '_')"
  cp "$envfile" "$DEST"
  echo "  ✓ $REL"
  COUNT=$((COUNT + 1))
done < <(find "$DEV_DIR" -name ".env*" \
  ! -path "*/.git/*" \
  ! -path "*/.env-backups/*" \
  ! -name ".env.example" \
  ! -name ".env.sample" \
  2>/dev/null)

# Keep last 14 days only
ls -dt "{{SSD_MOUNT}}/Dev/.env-backups"/*/ 2>/dev/null | tail -n +15 | xargs rm -rf 2>/dev/null

echo ""
echo "✅ Backed up $COUNT .env files → $BACKUP_DIR"
osascript -e "display notification \"Backed up $COUNT .env files\" with title \"🔐 .env Backup Done\""
