#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/aries-theme"
REPO_URL="git@github.com:generaitve-team/aries-theme-kit.git"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
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
  echo "" >> "$CLAUDE_MD"
  echo "$ARIES_BLOCK" >> "$CLAUDE_MD"
  echo "Added Aries instructions to $CLAUDE_MD"
fi

echo ""
echo "Skill location: $SKILL_DIR"
echo "Claude instructions: $CLAUDE_MD"
echo ""
echo "Start a new Claude Code session to activate."
echo "To update later, run this same command again."
