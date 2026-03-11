#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/aries-theme"
REPO_URL="git@github.com:generaitve-team/aries-theme.git"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
MARKER="## Aries Theme Kit"

# --- Step 1: Install or update the skill repo ---

mkdir -p "$HOME/.claude/skills"

if [ -d "$SKILL_DIR/.git" ]; then
  echo "Updating Aries Theme Kit..."
  cd "$SKILL_DIR" && git pull --ff-only
  echo "Updated! Your Aries theme skill is current."
else
  if [ -d "$SKILL_DIR" ]; then
    echo "Error: $SKILL_DIR exists but is not a git repo. Remove it first."
    exit 1
  fi
  echo "Installing Aries Theme Kit..."
  git clone "$REPO_URL" "$SKILL_DIR"
  echo "Installed!"
fi

# --- Step 2: Add instructions to ~/.claude/CLAUDE.md ---

ARIES_BLOCK="$MARKER

When the user asks you to build UI, create pages, set up a new project, or do any front-end work, ALWAYS use the aries-theme skill installed at ~/.claude/skills/aries-theme/. Read the SKILL.md file and follow its instructions for project setup, theming, and component usage. Never build UI from scratch without applying the Aries design system first."

if [ -f "$CLAUDE_MD" ] && grep -qF "$MARKER" "$CLAUDE_MD"; then
  echo "CLAUDE.md already has Aries instructions — skipping."
else
  # Back up before modifying
  if [ -f "$CLAUDE_MD" ]; then
    cp "$CLAUDE_MD" "$CLAUDE_MD.bak"
    echo "Backed up $CLAUDE_MD to $CLAUDE_MD.bak"
  fi
  printf '\n%s\n' "$ARIES_BLOCK" >> "$CLAUDE_MD"
  echo "Added Aries instructions to $CLAUDE_MD"
fi

# --- Step 3: Add shadcn MCP server to Claude settings ---

if [ -f "$CLAUDE_SETTINGS" ] && python3 -c "
import json, sys
with open('$CLAUDE_SETTINGS') as f:
    d = json.load(f)
sys.exit(0 if 'shadcn' in d.get('mcpServers', {}) else 1)
" 2>/dev/null; then
  echo "shadcn MCP server already configured — skipping."
else
  # Back up before modifying
  if [ -f "$CLAUDE_SETTINGS" ]; then
    cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak"
    echo "Backed up $CLAUDE_SETTINGS to $CLAUDE_SETTINGS.bak"
  fi

  python3 -c "
import json, os, sys

path = '$CLAUDE_SETTINGS'
d = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            d = json.load(f)
    except json.JSONDecodeError as e:
        print(f'Error: {path} contains invalid JSON: {e}', file=sys.stderr)
        print('Fix the file manually or restore from .bak, then re-run.', file=sys.stderr)
        sys.exit(1)

d.setdefault('mcpServers', {})['shadcn'] = {
    'command': 'npx',
    'args': ['shadcn@latest', 'mcp']
}

with open(path, 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"
  echo "Added shadcn MCP server to $CLAUDE_SETTINGS"
fi

echo ""
echo "Skill location: $SKILL_DIR"
echo "Claude instructions: $CLAUDE_MD"
echo "MCP config: $CLAUDE_SETTINGS"
echo ""
echo "Start a new Claude Code session to activate."
echo "To update later, run this same command again."
