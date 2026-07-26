# mac-ssd-toolkit

Use an external SSD as your Mac's primary storage — with automation, monitoring, and a terminal menu system.

Built for Macs with limited internal storage (128–256GB). Moves your dev projects, toolchains, and user folders to SSD transparently via symlinks, then automates backup, cleanup, and system health.

---

## What's included

### `ssd` — SSD Tools Menu (27 scripts)
| Category | Scripts |
|----------|---------|
| Storage | Mount check, cache cleanup, disk alert, duplicate finder, large file tracker, SSD health, auto-eject, folder dashboard |
| Dev | Node modules cleaner, dev backup, git status report, stale branch cleaner, dep audit, project switcher, env backup, port resolver, dep updater, daily dev log |
| System | Startup optimizer, app usage, RAM monitor, battery logger, serial lock |
| Productivity | Screenshot organizer, focus mode, meeting prep, dotfiles backup |

### `mac` — Mac Tools Menu (19 tools)
| Category | Tools |
|----------|-------|
| System | Live stats, battery health, wifi info, top processes |
| Apps | Kill hogs, app usage, startup items, force quit |
| Maintenance | Clear caches, brew update, run all agents, find large files |
| Security | Firewall status, open ports, lock screen, SSH keys |
| Power | Caffeinate, sleep timer, battery saver |

### LaunchAgents (18 automated tasks)
Nightly backups, cache cleanup, disk alerts, git status reports, dependency audits, battery logging — all scheduled via macOS launchd.

---

## Install

```bash
git clone https://github.com/sxrxvxnn/mac-ssd-toolkit
cd mac-ssd-toolkit
chmod +x install.sh
./install.sh
```

The installer will ask for:
- Your Mac username
- Your SSD volume name (e.g. `007`, `MySSD`)
- Your dev project names

Then run:
```bash
source ~/.zshrc
```

Type `ssd` or `mac` to launch.

---

## Requirements

- macOS 12+
- Homebrew (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`)
- An external SSD formatted as HFS+ or APFS

---

## Direct commands

```bash
ssd 5          # Run dev backup
ssd git-status # Run by name
mac 2          # Battery health
mac open-ports # Run by name
```

---

## Aliases installed

```bash
ssd        # SSD tools menu
mac        # Mac tools menu
dev        # cd to SSD Dev folder
gs         # git status
ga         # git add -A
gc         # git commit -m
gp         # git push
gl         # git log --oneline -10
freeup     # Clear caches
backup     # Run dev backup
focus      # Start focus mode (25min)
reload     # Reload .zshrc
```

---

## Uninstall

```bash
./uninstall.sh
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) — contributions welcome. New scripts, bug fixes, new mac tool ideas, platform improvements.

---

## License

MIT
