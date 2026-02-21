#!/usr/bin/env bash
set -euo pipefail

# Clawrari Bootstrap — The Ferrari of OpenClaw Setups
# https://clawrari.com

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
OPENCLAW_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
  echo ""
  echo -e "${RED}  ██████╗██╗      █████╗ ██╗    ██╗██████╗  █████╗ ██████╗ ██╗${NC}"
  echo -e "${RED} ██╔════╝██║     ██╔══██╗██║    ██║██╔══██╗██╔══██╗██╔══██╗██║${NC}"
  echo -e "${RED} ██║     ██║     ███████║██║ █╗ ██║██████╔╝███████║██████╔╝██║${NC}"
  echo -e "${RED} ██║     ██║     ██╔══██║██║███╗██║██╔══██╗██╔══██║██╔══██╗██║${NC}"
  echo -e "${RED} ╚██████╗███████╗██║  ██║╚███╔███╔╝██║  ██║██║  ██║██║  ██║██║${NC}"
  echo -e "${RED}  ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝${NC}"
  echo ""
  echo -e "${BOLD}  The Ferrari of OpenClaw Setups${NC}"
  echo -e "  ${CYAN}clawrari.com${NC}"
  echo ""
}

ask() {
  local prompt="$1"
  local default="$2"
  local result=""

  if [ -n "$default" ]; then
    echo -ne "${BOLD}${prompt}${NC} ${YELLOW}[${default}]${NC} "
  else
    echo -ne "${BOLD}${prompt}${NC} "
  fi
  read -r result
  echo "${result:-$default}"
}

ask_required() {
  local prompt="$1"
  local default="${2:-}"
  local result=""
  while true; do
    result=$(ask "$prompt" "$default")
    if [ -n "$result" ]; then
      echo "$result"
      return
    fi
    echo -e "${RED}  This one's required.${NC}"
  done
}

# Template rendering — replaces {{KEY}} with values
render_template() {
  local template="$1"
  local output="$2"
  local content
  content=$(cat "$template")

  content="${content//\{\{NAME\}\}/$USER_NAME}"
  content="${content//\{\{PRONOUNS\}\}/$USER_PRONOUNS}"
  content="${content//\{\{TIMEZONE\}\}/$USER_TIMEZONE}"
  content="${content//\{\{ROLE\}\}/$USER_ROLE}"
  content="${content//\{\{PRIORITY_1\}\}/$USER_PRIORITY_1}"
  content="${content//\{\{PRIORITY_2\}\}/$USER_PRIORITY_2}"
  content="${content//\{\{PRIORITY_3\}\}/$USER_PRIORITY_3}"
  content="${content//\{\{WAKE_TIME\}\}/$USER_WAKE_TIME}"
  content="${content//\{\{WRITING_STYLE\}\}/$USER_WRITING_STYLE}"
  content="${content//\{\{TONE\}\}/$USER_TONE}"
  content="${content//\{\{AI_NAME\}\}/$AI_NAME}"
  content="${content//\{\{AI_PERSONALITY\}\}/$AI_PERSONALITY}"
  content="${content//\{\{PLATFORMS\}\}/$USER_PLATFORMS}"
  content="${content//\{\{TOPICS\}\}/$USER_TOPICS}"
  content="${content//\{\{DATE\}\}/$TODAY}"

  echo "$content" > "$output"
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────

banner

echo -e "${CYAN}Let's set up your OpenClaw workspace. This takes about 2 minutes.${NC}"
echo ""

# Check OpenClaw exists
if ! command -v openclaw &> /dev/null; then
  echo -e "${YELLOW}Warning: 'openclaw' not found in PATH. We'll still generate the files.${NC}"
  echo -e "${YELLOW}Install OpenClaw first, then copy the workspace files.${NC}"
  echo ""
fi

# Check workspace
if [ -d "$OPENCLAW_DIR" ]; then
  echo -e "${YELLOW}Found existing workspace at $OPENCLAW_DIR${NC}"
  OVERWRITE=$(ask "Overwrite existing files? (y/n)" "n")
  if [ "$OVERWRITE" != "y" ] && [ "$OVERWRITE" != "Y" ]; then
    echo -e "${RED}Aborting. Your existing setup is safe.${NC}"
    exit 0
  fi
fi

echo -e "\n${BOLD}── About You ──${NC}\n"

USER_NAME=$(ask_required "What's your name?")
USER_PRONOUNS=$(ask "Pronouns (optional):" "")
USER_TIMEZONE=$(ask "Timezone:" "America/New_York")
USER_ROLE=$(ask_required "What do you do?")

echo -e "\n${BOLD}── Priorities ──${NC}\n"
echo -e "${CYAN}What should your AI focus on? Rank your top 3.${NC}\n"

USER_PRIORITY_1=$(ask_required "Top priority:")
USER_PRIORITY_2=$(ask "Second priority:" "")
USER_PRIORITY_3=$(ask "Third priority:" "")

echo -e "\n${BOLD}── Daily Rhythm ──${NC}\n"

USER_WAKE_TIME=$(ask "When do you usually wake up?" "7:00 AM")

echo -e "\n${BOLD}── Writing & Tone ──${NC}\n"

USER_WRITING_STYLE=$(ask "Writing style (concise/narrative/technical):" "concise")
USER_TONE=$(ask "Tone (professional/casual/balanced):" "balanced")

echo -e "\n${BOLD}── Your AI ──${NC}\n"

AI_NAME=$(ask "Name your AI:" "Claw")
AI_PERSONALITY=$(ask "Personality (sharp/warm/neutral):" "sharp")

echo -e "\n${BOLD}── Platforms & Topics ──${NC}\n"

USER_PLATFORMS=$(ask "Platforms you post to (comma-separated):" "twitter,linkedin")
USER_TOPICS=$(ask "Topics you care about (comma-separated):" "AI, engineering, startups")

# ──────────────────────────────────────────────
# Generate workspace
# ──────────────────────────────────────────────

TODAY=$(date +%Y-%m-%d)

echo ""
echo -e "${CYAN}Generating your workspace...${NC}"
echo ""

mkdir -p "$OPENCLAW_DIR"/{memory,tasks,drafts,reports,ideas,systems}

# Render templates
for tmpl in "$TEMPLATES_DIR"/*.tmpl; do
  filename=$(basename "$tmpl" .tmpl)
  render_template "$tmpl" "$OPENCLAW_DIR/$filename"
  echo -e "  ${GREEN}✓${NC} $filename"
done

# Create initial daily note
DAILY_NOTE="$OPENCLAW_DIR/memory/$TODAY.md"
cat > "$DAILY_NOTE" << EOF
# $TODAY

## Setup
- Clawrari bootstrap completed
- Workspace initialized with Clawrari v0.1.0
EOF
echo -e "  ${GREEN}✓${NC} memory/$TODAY.md"

# Create memory index files
for f in projects.md people.md preferences.md operating-rules.md; do
  if [ ! -f "$OPENCLAW_DIR/memory/$f" ]; then
    echo "# $(echo "$f" | sed 's/\.md//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')" > "$OPENCLAW_DIR/memory/$f"
    echo "" >> "$OPENCLAW_DIR/memory/$f"
    echo "_Add entries as you learn._" >> "$OPENCLAW_DIR/memory/$f"
    echo -e "  ${GREEN}✓${NC} memory/$f"
  fi
done

# Create task queue
if [ ! -f "$OPENCLAW_DIR/tasks/queue.md" ]; then
  cat > "$OPENCLAW_DIR/tasks/queue.md" << 'EOF'
# Task Queue

Add tasks here for your AI to work on overnight or during async time.

## Format
- [ ] Task description — context/links
EOF
  echo -e "  ${GREEN}✓${NC} tasks/queue.md"
fi

# Create ideas inbox
if [ ! -f "$OPENCLAW_DIR/ideas/inbox.md" ]; then
  cat > "$OPENCLAW_DIR/ideas/inbox.md" << 'EOF'
# Ideas Inbox

Quick capture. Your AI monitors this and processes ideas into projects.

---
EOF
  echo -e "  ${GREEN}✓${NC} ideas/inbox.md"
fi

echo ""
echo -e "${GREEN}${BOLD}Done.${NC} Your workspace is ready at ${CYAN}$OPENCLAW_DIR${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Review the generated files in $OPENCLAW_DIR"
echo -e "  2. Start OpenClaw: ${CYAN}openclaw gateway start${NC}"
echo -e "  3. Say hello to $AI_NAME"
echo ""
echo -e "${BOLD}Welcome to Clawrari. 🏎️${NC}"
