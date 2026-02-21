# Skill: Google Workspace (gog)

Calendar, Gmail, Drive. This is the backbone for “briefings”, “responsive checks”, and meeting prep.

## Install
```bash
openclaw skill install gog
```

## Common setup
Authenticate services you plan to use (example):
```bash
gog auth add you@yourdomain.com --services calendar,gmail,drive
```

## Common commands
```bash
gog calendar list --limit 10

gog gmail search "is:unread in:inbox" --limit 10

gog drive ls --limit 20
```
