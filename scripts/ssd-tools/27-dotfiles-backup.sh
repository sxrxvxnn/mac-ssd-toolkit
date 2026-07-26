#!/bin/zsh
# Backup critical dotfiles to SSD

BACKUP="{{SSD_MOUNT}}/Documents/.dotfiles-backup"
DATE=$(date +"%Y-%m-%d")
DEST="$BACKUP/$DATE"
mkdir -p "$DEST"

FILES=(
  "$HOME/.zshrc"
  "$HOME/.zshenv"
  "$HOME/.zprofile"
  "$HOME/.p10k.zsh"
  "$HOME/.gitconfig"
  "$HOME/.tmux.conf"
)

for f in "${FILES[@]}"; do
  [ -f "$f" ] && cp "$f" "$DEST/" && echo "  ✓ $(basename $f)"
done

# SSH config (no private keys — config only)
[ -f "$HOME/.ssh/config" ] && cp "$HOME/.ssh/config" "$DEST/ssh_config" && echo "  ✓ ssh config"

# Prune — keep last 14
ls -dt "$BACKUP"/*/ 2>/dev/null | tail -n +15 | xargs rm -rf 2>/dev/null

echo "✅ Dotfiles backed up → $DEST"
osascript -e "display notification \"Dotfiles saved ($DATE)\" with title \"✅ Dotfiles Backup\""
