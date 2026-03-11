---
name: aries-theme
description: >
  Aries design system for building UIs with the Aries visual identity.
  Use when creating new Next.js projects, building UI components, designing
  pages, or working on any project where Aries visual conventions should apply.
  Automatically activates when the user asks to build UI, create a page,
  or set up a new project.
---

# Aries Theme Kit

This skill teaches you to build UIs that match the Aries platform look and feel. The Aries design system uses a dark navy sidebar, card-based layouts, Inter typography, and a curated color palette built on top of shadcn/ui components.

The target user is non-technical. They describe what they want in plain language and you handle all technical decisions -- project creation, component installation, theming, and layout. Everything you build should be visually consistent with the Aries platform so that work can be integrated into the real application later.

## Mode Detection

Determine which mode to use based on the current project state:

### New Project Scaffold

Use this mode when the user says "create a new project" or "set up an app", or when no Next.js project exists in the working directory.

Steps:

1. Run `npx create-next-app@16` with these options: TypeScript, Tailwind CSS v4, App Router, `src/` directory enabled, import alias `@/*`
2. Run `npx shadcn@4 init` with new-york style, slate base color, CSS variables enabled
3. Install all baseline shadcn components (see [components.md](components.md) for the full list and install command) — this step MUST come before copying the theme because `shadcn add` overwrites globals.css
4. Copy `${CLAUDE_SKILL_DIR}/theme/globals.css` to `src/app/globals.css` — this MUST be the last file write to globals.css. The Aries template is the final word; nothing should modify it after this step.
5. Verify the theme was applied: confirm globals.css contains `--aries-navy` and `--sidebar: hsl(222.2 47.4% 11.2%)`. If either is missing, re-copy the template.
6. Set up the Inter font in the root layout (see Font Setup below)
7. Create the app shell layout: a root layout using SidebarProvider + SidebarInset, an AppSidebar component with the Aries logo (🐏 + "ARIES"), navigation items, and a user footer. The header bar must include SidebarTrigger, a Separator, and Breadcrumb. Copy the code from [references/layout-patterns.md](references/layout-patterns.md) — it has tested, working implementations of the app shell, sidebar, and breadcrumb system.

### Apply to Existing Project

Use this mode when a Next.js project already exists (detected by `next.config.*` or `next` in `package.json`).

Steps:

1. Check which baseline shadcn components are missing and install them (see [components.md](components.md)) — install components FIRST because `shadcn add` overwrites globals.css
2. Copy `${CLAUDE_SKILL_DIR}/theme/globals.css` to `src/app/globals.css` — this MUST happen AFTER all component installation. The Aries template is the final word.
3. Verify the theme was applied: confirm globals.css contains `--aries-navy` and `--sidebar: hsl(222.2 47.4% 11.2%)`. If either is missing, re-copy the template.
4. Verify the Inter font is set up in the root layout; add it if missing
5. Offer to set up Aries layout patterns (sidebar, card grids, etc.) if the project does not already have them

## Critical Rules

These rules are non-negotiable. Follow them in every project:

- **ALWAYS copy the theme file LAST.** Use `${CLAUDE_SKILL_DIR}/theme/globals.css` as the source of truth. NEVER generate globals.css from scratch or from memory. The template contains exact color values, typography utilities, and Tailwind v4 configuration that must match the Aries platform. **Critical ordering: `shadcn add` overwrites globals.css, so always install all components BEFORE copying the theme template. The theme copy must be the final write to globals.css.** After copying, verify the file contains `--aries-navy` and `--sidebar: hsl(222.2 47.4% 11.2%)`.

- **Sidebar brand block is mandatory.** Every app built with this theme displays a brand block in the sidebar header. The header MUST contain: a blue logo square (`h-8 w-8 rounded-lg bg-aries-primary`) with a white ram emoji (🐏) inside, followed by the app name in `text-xl font-semibold text-white uppercase`. Use the user's app name — if they say "build me a project tracker called Orion", the sidebar shows "ORION". Default to "ARIES" if no name is given.

- **Only build what's in the patterns.** Do not add UI elements that aren't described in [patterns.md](patterns.md) or [references/layout-patterns.md](references/layout-patterns.md). No floating action buttons, no FABs, no chat widgets, no bottom-right circles, no decorative flourishes. If the user didn't ask for it and the patterns don't describe it, don't add it.

- **Tailwind CSS v4 only.** Use CSS-based configuration with the `@theme inline` block in globals.css. NEVER create a `tailwind.config.ts` or `tailwind.config.js` file. All custom tokens are defined in the CSS file.

- **Light mode only.** The Aries platform uses light mode exclusively. The `.dark` block in globals.css exists for shadcn component compatibility only -- do not add dark mode theming or toggle functionality.

- **shadcn/ui components via CLI.** Install components using `npx shadcn@4 add [component]`. NEVER write component source code manually or ship component files as part of the skill. Components live in `src/components/ui/` and are read-only after installation.

- **Do NOT modify `src/components/ui/` files.** Customization happens at the usage site, not inside the base components. Use the `className` prop and `cn()` utility for styling overrides.

- **Use `cn()` for className merging.** Import from `@/lib/utils`. This is the standard pattern for composing Tailwind classes.

- **Use Aries typography utilities.** The theme defines five text utility classes: `text-heading-1`, `text-heading-2`, `text-heading-3`, `text-body`, and `text-label`. Use these instead of ad-hoc Tailwind text classes. Page titles use `text-heading-1`. Subtitles and descriptions use `text-body`. Metric labels and column headers use `text-label`. See [patterns.md](patterns.md) for when to use each.

- **shadcn MCP server.** When available, use the shadcn MCP server to look up component APIs and usage examples. This keeps documentation current without requiring skill updates. If the MCP server is not available, the baseline component list in [components.md](components.md) covers most needs.

- **Inter font required.** Load Inter via `next/font/google` with the CSS variable `--font-inter`. See Font Setup below. If text renders in a system font instead of Inter, the font setup is broken — check that the `<body>` tag has `${inter.variable} font-sans` classes.

## References

The skill has two layers of documentation. **Always check the code templates first** — they are tested, working implementations. Fall back to the prose patterns when adapting to a novel layout.

### Code templates (use these when building)

These files contain complete, copy-pasteable code for the app shell and page layouts. When scaffolding a new project or adding standard pages, read these files and use their code directly:

- **Layout templates** (app shell, sidebar, breadcrumb, page patterns): see [references/layout-patterns.md](references/layout-patterns.md)
- **Component usage** (buttons, cards, tables, forms, badges, alerts, toasts with code examples): see [references/component-guide.md](references/component-guide.md)
- **Scaffold walkthrough** (step-by-step new project setup): see [references/scaffold.md](references/scaffold.md)

### Design intent (use these when adapting)

These files describe the visual DNA of Aries in prose. Use them when building something that doesn't have an exact template — they explain the principles so you can make the right decisions:

- **Visual patterns** (layout philosophy, color usage, typography rules, spacing): see [patterns.md](patterns.md)
- **Baseline component list** (all 27 shadcn components with install command): see [components.md](components.md)

### Theme file

- **CSS template**: `${CLAUDE_SKILL_DIR}/theme/globals.css` — copy verbatim, never generate from memory

## shadcn components.json

When initializing shadcn in a new project, the resulting `components.json` should match this configuration:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/app/globals.css",
    "baseColor": "slate",
    "cssVariables": true,
    "prefix": ""
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  }
}
```

If `npx shadcn@4 init` produces different defaults, adjust the config to match the above. The key settings are: new-york style, no tailwind config file (empty string -- Tailwind v4 uses CSS), slate base color, CSS variables enabled, and `@/` path aliases.

## Font Setup

The Aries design system uses the Inter font family. Set it up in the root layout file (`src/app/layout.tsx`):

```tsx
import { Inter } from "next/font/google";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
});

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={`${inter.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
```

The `--font-inter` CSS variable is referenced by the theme's `--font-sans` token in globals.css, ensuring all text renders in Inter throughout the application.

## Scope

This design system is about look and feel. It does not include application-specific business logic, mock data, domain types, or APIs. Build whatever the user asks for -- just make it look like Aries.

## Installation

To install this skill globally (so it applies to all projects):

```bash
git clone git@github.com:generaitve-team/aries-theme.git ~/.claude/skills/aries-theme
```

To update to the latest version:

```bash
cd ~/.claude/skills/aries-theme && git pull
```

Both commands are idempotent and safe to re-run at any time.
