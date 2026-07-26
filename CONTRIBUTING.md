# Contributing to mac-ssd-toolkit

Contributions are welcome — new scripts, bug fixes, improvements, ideas.

---

## Ways to contribute

### 1. Add a new script
Have a useful automation? Add it.

- SSD scripts go in `scripts/ssd-tools/` — name it `NN-your-script.sh`
- Mac tools go in `scripts/mac-tools/` as a new case in `mac.sh`
- Use `{{SSD_MOUNT}}` and `{{USERNAME}}` as placeholders (replaced by installer)

Script template:
```bash
#!/bin/zsh
# One-line description of what this does

SSD="{{SSD_MOUNT}}"

echo "▶ Your script name"
echo "─────────────────────────────────────"

# your code here

echo "✅ Done"
osascript -e "display notification \"Done\" with title \"✅ Script Name\""
```

### 2. Report a bug
Open an issue using the **Bug Report** template. Include:
- macOS version
- SSD format (HFS+ / APFS)
- What you ran, what happened, what you expected

### 3. Request a feature
Open an issue using the **Feature Request** template. Describe the automation or tool you'd find useful.

### 4. Improve the installer
The installer (`install.sh`) handles path substitution and LaunchAgent setup. Improvements to make it more robust are very welcome.

---

## Guidelines

- Scripts must work without root (no `sudo`) where possible
- Use `{{SSD_MOUNT}}` and `{{USERNAME}}` — never hardcode paths
- Keep scripts focused — one clear purpose per file
- Add a one-line comment at the top describing what it does
- Test on your own machine before opening a PR

---

## Opening a PR

1. Fork the repo
2. Create a branch: `git checkout -b add-my-script`
3. Add your script + test it
4. Update `scripts/ssd-tools/ssd.sh` menu array (if adding SSD script) or `mac.sh` case (if adding mac tool)
5. Open a PR with a short description of what it does and why it's useful

---

## Ideas wanted

If you have ideas but can't code them, open a **Feature Request** issue. Others can pick it up.

Current ideas list:
- [ ] Git commit streaks tracker
- [ ] Wifi speed logger (daily)
- [ ] iCloud storage usage report
- [ ] Auto-organize Downloads by file type
- [ ] Monthly storage trend report
- [ ] Slack/Discord DND sync with focus mode
- [ ] Dock layout backup/restore
