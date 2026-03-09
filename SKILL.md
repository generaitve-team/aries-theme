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

1. Run `npx create-next-app@latest` with these options: TypeScript, Tailwind CSS v4, App Router, `src/` directory enabled, import alias `@/*`
2. Run `npx shadcn@latest init` with new-york style, slate base color, CSS variables enabled
3. Copy `${CLAUDE_SKILL_DIR}/theme/globals.css` to `src/app/globals.css` (overwrite the generated one)
4. Install all baseline shadcn components (see [components.md](components.md) for the full list and install command)
5. Set up the Inter font in the root layout (see Font Setup below)
6. If the user is building a full application (not a single page), create an app shell layout with a sidebar using the patterns described in [patterns.md](patterns.md)

### Apply to Existing Project

Use this mode when a Next.js project already exists (detected by `next.config.*` or `next` in `package.json`).

Steps:

1. Copy `${CLAUDE_SKILL_DIR}/theme/globals.css` to `src/app/globals.css` (replace the existing one with the Aries theme)
2. Check which baseline shadcn components are missing and install them (see [components.md](components.md))
3. Verify the Inter font is set up in the root layout; add it if missing
4. Offer to set up Aries layout patterns (sidebar, card grids, etc.) if the project does not already have them

## Critical Rules

These rules are non-negotiable. Follow them in every project:

- **ALWAYS copy the theme file.** Use `${CLAUDE_SKILL_DIR}/theme/globals.css` as the source of truth. NEVER generate globals.css from scratch or from memory. The template contains exact color values, typography utilities, and Tailwind v4 configuration that must match the Aries platform.

- **Tailwind CSS v4 only.** Use CSS-based configuration with the `@theme inline` block in globals.css. NEVER create a `tailwind.config.ts` or `tailwind.config.js` file. All custom tokens are defined in the CSS file.

- **Light mode only.** The Aries platform uses light mode exclusively. The `.dark` block in globals.css exists for shadcn component compatibility only -- do not add dark mode theming or toggle functionality.

- **shadcn/ui components via CLI.** Install components using `npx shadcn@latest add [component]`. NEVER write component source code manually or ship component files as part of the skill. Components live in `src/components/ui/` and are read-only after installation.

- **Do NOT modify `src/components/ui/` files.** Customization happens at the usage site, not inside the base components. Use the `className` prop and `cn()` utility for styling overrides.

- **Use `cn()` for className merging.** Import from `@/lib/utils`. This is the standard pattern for composing Tailwind classes.

- **shadcn MCP server.** When available, use the shadcn MCP server to look up component APIs and usage examples. This keeps documentation current without requiring skill updates. If the MCP server is not available, the baseline component list in [components.md](components.md) covers most needs.

- **Inter font required.** Load Inter via `next/font/google` with the CSS variable `--font-inter`. See Font Setup below.

## References

For detailed guidance on specific topics, see these supporting files:

- **Aries visual patterns** (layouts, cards, tables, forms, detail pages, color usage, typography): see [patterns.md](patterns.md)
- **Baseline component list** (all 27 shadcn components with install command and usage notes): see [components.md](components.md)
- **Theme template file**: `${CLAUDE_SKILL_DIR}/theme/globals.css`

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

If `npx shadcn@latest init` produces different defaults, adjust the config to match the above. The key settings are: new-york style, no tailwind config file (empty string -- Tailwind v4 uses CSS), slate base color, CSS variables enabled, and `@/` path aliases.

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
git clone https://github.com/generaitve-team/aries-theme-kit.git ~/.claude/skills/aries-theme
```

To update to the latest version:

```bash
cd ~/.claude/skills/aries-theme && git pull
```

Both commands are idempotent and safe to re-run at any time.
