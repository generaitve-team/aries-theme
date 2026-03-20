# Architecture

**Analysis Date:** 2026-03-20

## Pattern Overview

**Overall:** Aries Theme Kit is a **Claude Code skill** — a reusable, installable design system package that teaches Claude how to build UIs with consistent visual identity and layout patterns. The architecture follows a dual-mode scaffolding system: it handles both new project creation (full Next.js + shadcn setup) and integration into existing projects (component installation + theme application).

**Key Characteristics:**
- **Skill-based architecture** — Designed as a standalone, installable package (`~/.claude/skills/aries-theme/`) that operates via Claude Code agents
- **Template-driven code generation** — Uses copy-paste code templates rather than programmatic generation
- **Two-mode operation** — Detects project state and applies appropriate setup sequence (new project scaffold vs. existing project reskin)
- **Theme-last ordering** — Critical sequencing ensures shadcn component installation happens before theme file copy to prevent overwrites
- **Reference-based patterns** — Separates design intent (prose patterns) from implementation templates (copy-paste code)

## Layers

**Design Intent Layer:**
- Purpose: Define the visual principles, layout patterns, and usage guidelines for Aries-branded UIs
- Location: `patterns.md`, `components.md`, `references/*.md`
- Contains: Prose descriptions of visual patterns, component usage notes, typography rules, color guidelines, spacing standards
- Depends on: shadcn/ui component library, Tailwind CSS v4
- Used by: Claude Code (both human-readable and programmatic guidance for UI development)

**Theme & Style Layer:**
- Purpose: Provide the complete CSS configuration that implements the Aries visual identity
- Location: `theme/globals.css`
- Contains: Tailwind v4 CSS-based config with custom tokens (colors, typography utilities, spacing), shadcn integration, Aries brand color palette
- Depends on: Tailwind CSS v4, shadcn/ui CSS, tw-animate-css
- Used by: All Aries projects (copied verbatim as `src/app/globals.css`)

**Code Template Layer:**
- Purpose: Supply tested, copy-paste implementations of app shell, layouts, and page patterns
- Location: `references/layout-patterns.md`, `references/component-guide.md`, `references/scaffold.md`
- Contains: Complete TSX/TypeScript code for root layout, app shell, sidebar, breadcrumb, form patterns, component usage examples
- Depends on: shadcn/ui components, react-hook-form, zod validation, Lucide icons
- Used by: Skill implementation (Claude reads and copies code directly into projects)

**Installation & Onboarding Layer:**
- Purpose: Handle skill installation and project setup automation
- Location: `scripts/install.sh`, `scripts/install.ps1`
- Contains: Bash/PowerShell scripts that clone repo to `~/.claude/skills/`, update global `.claude/CLAUDE.md`, register shadcn MCP server
- Depends on: Git, Node.js, filesystem access
- Used by: Users installing the skill for the first time

**Skill Metadata & Commands:**
- Purpose: Register the skill with Claude Code and provide orchestration commands
- Location: `SKILL.md` (manifest), `.claude/commands/gsd/` (GSD commands), `.claude/agents/` (agent definitions)
- Contains: Skill activation rules, mode detection logic, critical rule definitions, integration with GSD workflow system
- Depends on: Claude Code skill registry, GSD framework
- Used by: Claude Code orchestration and `/gsd` commands

## Data Flow

**New Project Mode:**

1. User requests "create a new project" → Claude detects no `next.config.*` file
2. Claude runs `npx create-next-app@16` with hardcoded options (TypeScript, Tailwind v4, App Router, `src/` dir, `@/*` alias)
3. Claude runs `npx shadcn@4 init` with new-york style, slate base color, CSS variables enabled
4. Claude installs all 27 baseline components in single command: `npx shadcn@4 add alert avatar badge ...` (this overwrites `globals.css`)
5. Claude reads `theme/globals.css` and writes it verbatim to `src/app/globals.css` (overwrites shadcn's version)
6. Claude reads `references/layout-patterns.md` and copies root layout code to `src/app/layout.tsx`
7. Claude creates `(app)/layout.tsx` with SidebarProvider + AppSidebar + header + breadcrumb
8. Claude creates `AppSidebar` component with brand block, navigation, footer (reads pattern from `references/layout-patterns.md`)
9. Project ready with working app shell and baseline components

**Existing Project Mode:**

1. User opens existing Next.js project → Claude detects `next.config.*` or `next` in `package.json`
2. Claude checks which baseline components are installed
3. Claude installs missing components via `npx shadcn@4 add [component]` (overwrites `globals.css`)
4. Claude reads `theme/globals.css` and writes it verbatim to `src/app/globals.css`
5. Claude verifies Inter font is set up in root layout; adds if missing
6. Claude offers to add Aries layout patterns if not already present

**State Management:**

- **No application state** — Aries Theme Kit is a design system, not a data layer
- **CSS variables as tokens** — All visual state (colors, spacing, typography) defined as CSS custom properties in `theme/globals.css`
- **Theme tokens referenced at usage** — Components use `cn()` to merge Tailwind classes with CSS variable-based utilities (e.g., `text-heading-1`, `bg-aries-primary`)
- **Component defaults from shadcn** — Form state (react-hook-form), dialog state (shadcn Dialog), toast state (sonner) managed by underlying libraries

## Key Abstractions

**Aries Color Palette:**
- Purpose: Semantic color tokens that map to brand values
- Examples: `--aries-navy`, `--aries-primary`, `--aries-success`, `--aries-warning`, `--aries-danger`
- Pattern: CSS custom properties defined in `:root` scope in `theme/globals.css`
- Used for: Brand-specific styling; allows easy future rebranding by editing one CSS file

**Typography Utility System:**
- Purpose: Five pre-composed text styles that ensure consistent visual hierarchy
- Examples: `text-heading-1` (2xl semibold), `text-heading-2` (xl semibold), `text-heading-3` (lg medium), `text-body` (sm muted), `text-label` (xs uppercase)
- Pattern: Layered Tailwind utilities defined in `@layer utilities` in `theme/globals.css`
- Used for: Page titles, section headers, body copy, labels; eliminates ad-hoc font sizing

**Baseline Component Kit:**
- Purpose: 27 pre-selected shadcn/ui components that cover 95% of common UI needs
- Examples: button, card, input, form, table, sidebar, dialog, toast, tabs, badge
- Pattern: Installed via single `npx shadcn@4 add [list]` command; lives in `src/components/ui/` (read-only after install)
- Used for: Rapid UI building without custom component authorship

**Layout Pattern Templates:**
- Purpose: Tested TSX structures for common application layouts
- Examples: Root layout, app shell, sidebar, breadcrumb, detail page with tabs, form layout, dashboard card grid
- Pattern: Complete code examples in `references/layout-patterns.md` and `references/component-guide.md`
- Used for: Copy-paste starting point for new pages/layouts

**cn() Utility Function:**
- Purpose: Safe merging of Tailwind CSS classes with custom overrides
- Examples: `cn("p-4", isActive && "bg-blue-500")` produces correct Tailwind output without class conflicts
- Pattern: Implemented in `src/lib/utils.ts` as `twMerge(clsx(...))` (uses clsx + tailwind-merge libraries)
- Used for: All conditional class application; required utility for component styling

## Entry Points

**User-Facing Entry Points:**

**Skill Installation:**
- Location: `scripts/install.sh` (Mac/Linux) or `scripts/install.ps1` (Windows)
- Triggers: User runs installer script
- Responsibilities: Clone repo to `~/.claude/skills/aries-theme/`, update `~/.claude/CLAUDE.md` with global instruction, register shadcn MCP server in `~/.claude/settings.json`

**Skill Activation (SKILL.md):**
- Location: `SKILL.md`
- Triggers: Claude detects UI task in any project (automatic via skill manifest)
- Responsibilities: Read skill instructions, determine new vs. existing project mode, orchestrate appropriate setup sequence

**New Project Scaffold:**
- Entry: Claude runs `npx create-next-app@16` with hardcoded parameters
- Triggers: User says "create a new project" or "set up an app"
- Responsibilities: Create Next.js project, initialize shadcn, install components, copy theme, set up root layout, create app shell

**Existing Project Reskin:**
- Entry: Claude checks `next.config.*` presence
- Triggers: User says "apply Aries theme" to existing Next.js project
- Responsibilities: Install missing components, apply theme file, verify font setup

**Developer-Facing Entry Points:**

**Layout Templates:**
- Location: `references/layout-patterns.md`
- Used by: Developers copying app shell and sidebar code into new projects
- Provides: Complete working TSX for root layout, app shell layout, sidebar component, breadcrumb system

**Component Guide:**
- Location: `references/component-guide.md`
- Used by: Developers learning button variants, card patterns, form composition, badge usage
- Provides: Usage examples and best practices for each baseline component

**Design Patterns:**
- Location: `patterns.md` (visual intent) + `references/scaffold.md` (step-by-step walkthrough)
- Used by: Developers building custom layouts not covered by templates
- Provides: Prose guidance on layout philosophy, color mapping, typography rules

## Error Handling

**Strategy:** Preventive design with validation checkpoints rather than error recovery

**Patterns:**

**Theme Verification:**
- After copying `theme/globals.css`, verify file contains `--aries-navy` and `--sidebar: hsl(222.2 47.4% 11.2%)`
- If missing, re-copy the template (indicates copy operation failed or incorrect source file)

**Component Installation Checkpoints:**
- After `npx shadcn@4 init`, verify `components.json` matches expected config (style: "new-york", CSS variables enabled, `@/` aliases set)
- If incorrect, manually adjust `components.json` to match template values

**Font Setup Verification:**
- After layout setup, verify root layout contains `${inter.variable} font-sans antialiased` in body className
- If text renders in system font instead of Inter, font setup is broken — check variable assignment

**Ordering Constraints:**
- Component installation must happen BEFORE theme copy (shadcn `add` overwrites `globals.css`)
- Theme copy must be final write to `globals.css` (nothing should modify after copy)
- Root layout must be set up AFTER theme copy (ensures Inter font variable is available)

## Cross-Cutting Concerns

**Logging:** No logging layer — skill operates via visual feedback to user (Claude explains each step) and visual verification (user sees theme applied in browser)

**Validation:** Pre-emptive via hardcoded configuration values and template verification:
- Next.js project created with exact parameters (TypeScript, Tailwind v4, App Router, `src/` dir)
- shadcn initialized with exact config (new-york, slate, CSS variables)
- Baseline components installed via single command (ensures consistency)
- Theme file copied verbatim (prevents configuration drift)

**Authentication:** Not applicable — Aries Theme Kit is a local design system package with no external API integration

**Dependency Management:**
- Core dependencies installed via `npm install`: lucide-react, class-variance-authority, clsx, tailwind-merge, sonner, tw-animate-css
- shadcn components installed via CLI (dependencies added automatically)
- No explicit version pinning in skill docs except Next.js@16, Tailwind v4, shadcn@4
- Dependencies defined in `references/scaffold.md` and implied by `SKILL.md` critical rules

---

*Architecture analysis: 2026-03-20*
