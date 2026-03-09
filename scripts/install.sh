#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/aries-theme"
REPO_URL="https://github.com/generaitve-team/aries-theme-kit.git"

# Ensure ~/.claude/skills/ exists
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
  echo "Installed! The Aries theme skill is now active in Claude Code."
fi

echo ""
echo "Skill location: $SKILL_DIR"
echo "To update later, run this same command again."
