# Connector Auth Walkthrough Recipe

How to authenticate the core connectors in Clawrari so your AI can actually do things on your behalf — calendar, email, docs, code, and comms.

## The Problem

A configured connector that can't authenticate is dead weight. Auth is the most common blocker in fresh Clawrari setups. This recipe walks through each connector family.

## Google Workspace (`gws-*`)

**What it enables:** Calendar, Drive, Docs, Sheets, Gmail, Tasks, Chat, Meet, Forms, Keep, Slides, People, Admin.

### Setup

1. **Create a GCP project** (or use an existing one):
   ```bash
   # In Google Cloud Console → IAM & Admin → Create Project
   # Note your project ID (e.g., "my-claw-project")
   ```

2. **Enable the APIs** you need:
   - Calendar API (`calendar-json.googleapis.com`)
   - Drive API (`drive.googleapis.com`)
   - Docs API (`docs.googleapis.com`)
   - Sheets API (`sheets.googleapis.com`)
   - Gmail API (`gmail.googleapis.com`)
   - Tasks API (`tasks.googleapis.com`)

3. **Create OAuth 2.0 credentials:**
   - Go to APIs & Services → Credentials → Create Credentials → OAuth client ID
   - Application type: Desktop app
   - Download the client secret JSON

4. **Authenticate via the CLI:**
   ```bash
   gws auth login
   # Opens browser → sign in → authorize → token stored in keyring
   ```

5. **Verify:**
   ```bash
   gws calendar events list --calendar primary --maxResults 1
   ```

### Troubleshooting

- **"Access blocked" error:** Your OAuth consent screen needs to be configured. Add your email as a test user if the app is in "Testing" mode.
- **Token expired:** Run `gws auth login` again. Tokens refresh automatically but can expire after inactivity.
- **Scope too narrow:** If you get 403 on a specific API, check that you enabled that API in the GCP console AND requested the right scope during auth.

## GitHub (`gh`)

**What it enables:** Repo management, PRs, issues, CI, code review.

### Setup

1. **Install the GitHub CLI:**
   ```bash
   brew install gh
   ```

2. **Authenticate:**
   ```bash
   gh auth login
   # Choose: GitHub.com → HTTPS → Login with a web browser
   ```

3. **Verify:**
   ```bash
   gh repo view prasithg/clawrari --json name,description
   ```

### Minimum scopes needed

- `repo` (full repository access)
- `read:org` (if working with org repos)
- `workflow` (if triggering CI)

## Claude Code (Anthropic)

**What it enables:** Background coding agent. Primary night-work executor.

### Setup

1. **Install Claude Code:**
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **Authenticate:**
   ```bash
   claude auth login
   # Opens browser → sign in with Anthropic account
   ```

3. **Critical config:** Always launch with `ANTHROPIC_API_KEY=` (unset) to prevent env-var conflicts in background mode:
   ```bash
   ANTHROPIC_API_KEY= claude --permission-mode bypassPermissions
   ```

4. **Verify:**
   ```bash
   echo 'List the files in the current directory' | ANTHROPIC_API_KEY= claude --permission-mode bypassPermissions 2>&1 | head -5
   ```

## Codex CLI (OpenAI)

**What it enables:** Alternative coding agent. Fallback for Claude Code.

### Setup

1. **Install Codex:**
   ```bash
   npm install -g @openai/codex
   ```

2. **Authenticate:**
   ```bash
   codex auth
   # Opens browser → sign in with OpenAI account
   ```

3. **Verify:**
   ```bash
   echo 'What is 2+2?' | codex 2>&1 | head -5
   ```

## Telegram (Control Channel)

**What it enables:** Primary communication channel between you and your AI.

### Setup

1. **Create a Telegram Bot** via [@BotFather](https://t.me/BotFather):
   ```
   /newbot → give it a name → save the API token
   ```

2. **Configure in OpenClaw** (in your agent config):
   ```json
   {
     "channels": {
       "telegram": {
         "token": "<your-bot-token>"
       }
     }
   }
   ```

3. **Start a chat** with your bot in Telegram and send any message to establish the connection.

## General Auth Principles

| Principle | Why |
|-----------|-----|
| Use OAuth over API keys when available | Better security, easier rotation |
| Store tokens in keyring, not env files | Prevents accidental commits |
| Test each connector immediately after setup | Catches scope issues early |
| Document which account each connector uses | Avoids confusion with multiple accounts |
| Re-auth after long inactivity periods | Most tokens expire eventually |

## Verification Checklist

After setting up all connectors, run through:

- [ ] `gws calendar events list` returns calendar data
- [ ] `gh repo view` returns repo info
- [ ] Claude Code responds to a piped prompt
- [ ] Codex responds to a piped prompt
- [ ] Telegram bot receives and responds to a message
- [ ] All credentials are in keyring (not in `.env` or config files committed to git)
