# External Integrations

**Analysis Date:** 2026-03-20

## APIs & External Services

**GitHub:**
- **Repository:** `https://github.com/generaitve-team/aries-theme.git`
  - Used for: Skill installation and updates
  - SDK/Client: Native git clone
  - Auth: Public repository (no auth required)

**shadcn/ui Component Registry:**
- **MCP Server:** `shadcn@latest mcp` (registered in Claude Code settings)
  - Used for: Real-time component API lookup and documentation
  - Registration: Configured in `~/.claude/settings.json` by installer
  - Command: `npx shadcn@latest mcp`

**Google Fonts:**
- **Service:** next/font/google
  - Used for: Inter font family delivery
  - No auth required (Google CDN, public API)
  - Loaded in root layout via `Inter` component

**npm Registry:**
- **Package Manager:** npm
  - Used for: Installing shadcn/ui, dependencies, and dependencies
  - Commands: `npm install`, `npx` for CLI tools
  - Auth: Public packages (no credentials required for baseline)

## Data Storage

**Databases:**
- Not applicable - This is a design system skill, not a backend application
- Projects built with Aries may use any database; the design system provides no persistence layer

**File Storage:**
- Local filesystem only
- Aries theme files stored in project `src/app/globals.css` and `src/components/ui/`
- No cloud storage integrations

**Caching:**
- None - This is a build-time theming system
- Component libraries cached locally in `node_modules/`

## Authentication & Identity

**Auth Provider:**
- Not applicable to design system itself
- Projects using Aries can implement any auth system (Auth0, Supabase, custom, etc.)

**Installation Identity:**
- Git user identity used for cloning repo (inherited from system git config or GitHub CLI)
- No authentication required for public repository

## Monitoring & Observability

**Error Tracking:**
- None - Design system has no runtime error tracking

**Logs:**
- Installation script outputs to stdout/stderr
- No persistent logging

## CI/CD & Deployment

**Hosting:**
- GitHub repository at `github.com/generaitve-team/aries-theme`
- Installation via curl/PowerShell from raw GitHub URLs

**CI Pipeline:**
- None defined in this repo
- Projects built with Aries can use any CI/CD platform

## Environment Configuration

**Required env vars:**
- None required for design system itself
- No secrets needed to use Aries

**Secrets location:**
- Not applicable - No credentials used by design system
- Projects built with Aries manage their own secrets via `.env` files

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None

## Installation & Updates

**Initial Installation:**
```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/generaitve-team/aries-theme/main/scripts/install.sh | bash

# Windows PowerShell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/generaitve-team/aries-theme/main/scripts/install.ps1" -OutFile "$env:TEMP\install-aries.ps1"; & "$env:TEMP\install-aries.ps1"
```

**Update Check:**
- Installer detects existing installation at `~/.claude/skills/aries-theme/`
- If installed, runs `git pull --ff-only` to check for updates
- Idempotent - safe to re-run at any time

## Claude Code Skill Registration

**Location:** `~/.claude/skills/aries-theme/`

**Configuration Files Modified:**
- `~/.claude/CLAUDE.md` - Adds `## Aries Theme Kit` section with global instructions
- `~/.claude/settings.json` - Registers shadcn MCP server

**Detection Logic:**
- Installer checks for `.git` directory to detect existing installation
- Prevents reinstall conflicts by validating installation state

## Project-Level Dependency Flow

When Claude scaffolds a new project or applies Aries to an existing one:

1. **Dependencies installed:** Via `npm install` or `npx shadcn@4 add`
2. **Components downloaded:** 27 baseline shadcn components from npm registry
3. **Theme applied:** Aries globals.css (from `theme/globals.css` in skill directory) copied to `src/app/globals.css`
4. **Fonts loaded:** Inter from Google Fonts API at runtime via `next/font/google`
5. **MCP service:** shadcn MCP server available for component lookups during development

---

*Integration audit: 2026-03-20*
