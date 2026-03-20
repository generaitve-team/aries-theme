# Codebase Concerns

**Analysis Date:** 2026-03-20

## Tech Debt

**Critical Ordering Dependency in Scaffolding:**
- Issue: Installation order is brittle — `shadcn add` overwrites `globals.css`, so theme must be copied LAST. If this order is violated, colors and typography break silently. The order is documented in SKILL.md and scaffold.md but enforced only by documentation, not code.
- Files: `SKILL.md` (lines 29-30, 42, 51), `references/scaffold.md` (lines 33, 43)
- Impact: Users who follow steps out of order will end up with broken theming that's hard to diagnose. The app will render but colors/fonts won't match Aries standards.
- Fix approach: Add a verification step to the scaffolding instructions that checks globals.css contains `--aries-navy` before proceeding. Better: Create a simple verification script that CLI tools call after each step.

**Hardcoded Repository URLs in Installer Scripts:**
- Issue: Both `scripts/install.sh` (line 5) and `scripts/install.ps1` (line 23) hardcode GitHub URLs using https. No fallback for network issues or git configuration.
- Files: `scripts/install.sh` (line 5), `scripts/install.ps1` (line 23)
- Impact: Network failures during clone leave users with incomplete installations. SSH config is not respected; users with SSH-only access may fail.
- Fix approach: Add retry logic with exponential backoff. Support both https and ssh URLs with fallback. Add better error messaging that suggests solutions (check internet, check git SSH config).

**Template String Placeholder Contamination Risk:**
- Issue: Multiple reference documents use placeholder text like `YOUR_APP_NAME`, `APP_NAME`, `APP_DESCRIPTION`, `UN` (user initials fallback). If Claude copies these as-is without substitution, the generated app will have broken branding.
- Files: `references/layout-patterns.md` (line 30-31, 214), `references/scaffold.md` (line 77-78), `references/component-guide.md`
- Impact: Users may end up with literal "YOUR_APP_NAME" in their sidebar instead of their actual project name.
- Fix approach: Adopt a clear placeholder convention (e.g., `{APP_NAME}` with braces) and document that Claude must substitute all placeholder values. Add a verification checklist to SKILL.md.

**No Version Pinning in Component Installation:**
- Issue: `components.md` (line 10) and `scaffold.md` (line 36) install shadcn@4 without pinning to a specific version patch. New releases of shadcn could introduce breaking changes or layout shifts.
- Files: `components.md` (line 10), `scaffold.md` (line 36), `references/scaffold.md` (line 35)
- Impact: Installations made months apart may have different component APIs or CSS rendering, breaking consistency across projects.
- Fix approach: Pin to a specific patch version: `npx shadcn@4.8.0 add` (or current latest) instead of `shadcn@4`.

**Font Verification Logic Incomplete:**
- Issue: SKILL.md (line 71) documents that Inter font setup can fail silently — "If text renders in a system font instead of Inter, the font setup is broken". No automated check exists.
- Files: `SKILL.md` (line 71), `references/scaffold.md` (line 124-125)
- Impact: Users may not notice font rendering is wrong, degrading the visual consistency of their Aries projects.
- Fix approach: Add a simple font verification function to check that CSS variable `--font-inter` is applied and fallback chain is correct.

## Known Bugs

**TooltipProvider Nesting Issue (Recently Fixed):**
- Symptoms: Tooltips crash when `TooltipProvider` is not properly positioned in the component tree. Happens when sidebar is used without TooltipProvider wrapping SidebarProvider.
- Files: `references/layout-patterns.md` (lines 65, 118-119, 140-141)
- Trigger: Creating an app shell without wrapping SidebarProvider in TooltipProvider
- Status: Fixed in recent commit (`2a37ee4: fix: add TooltipProvider to app shell layout template`), but the fix is only in the template. Users copying old code will encounter this.
- Mitigation: The current layout-patterns.md template shows correct nesting. Users must follow the template exactly.

**Sidebar Width CSS Variable Documented But Not Exposed:**
- Symptoms: References to `--sidebar-width` in `references/layout-patterns.md` (line 280) but not defined in `theme/globals.css`.
- Files: `references/layout-patterns.md` (line 280), `theme/globals.css` (no --sidebar-width defined)
- Trigger: Custom sidebar styling that tries to override width
- Workaround: Width is handled by shadcn's internal CSS. Custom width changes require modifying `src/components/ui/sidebar.tsx`.
- Fix approach: Either define --sidebar-width in globals.css for users to override, or remove the reference from the documentation.

## Fragile Areas

**Layout Pattern Documentation Inconsistency:**
- Files: `references/layout-patterns.md`, `references/scaffold.md`, `patterns.md`
- Why fragile: Multiple layout pattern documents exist with slightly different code examples. Layout updates to one document don't cascade to others. The `HeaderBreadcrumb` function in layout-patterns.md has complex path logic that's easy to break with typos.
- Safe modification: Always update ALL three documentation files when changing layout recommendations. Test the HeaderBreadcrumb path parsing with multiple URL depths.
- Test coverage: The breadcrumb auto-generation logic is prose-only; no test file validates it works for nested routes like `/dashboard/projects/123/settings`.

**Component Installation Order Enforcement:**
- Files: `SKILL.md` (lines 29-30, 42, 51), `references/scaffold.md` (step 3), `components.md` (line 13)
- Why fragile: The "install components BEFORE copying theme" rule is critical but only documented. No code enforces it. Users following SKILL.md step-by-step might read the critical rules last.
- Safe modification: Restructure SKILL.md to show the critical rules FIRST, before any step-by-step instructions. Add a prominent warning box.
- Test coverage: No automated check validates the order. Manual verification only.

**Aries Color Tokens Dependency:**
- Files: `theme/globals.css` (lines 103-108), `SKILL.md` (line 51), `patterns.md` (lines 59-75)
- Why fragile: The entire visual system depends on six color tokens (`--aries-navy`, `--aries-navy-light`, `--aries-primary`, `--aries-success`, `--aries-warning`, `--aries-danger`). If any token is missing or misspelled, components referencing them silently fall back to defaults, breaking the look.
- Safe modification: Always verify all six tokens are present in globals.css after any theme edits. Use grep to check: `grep "aries-" theme/globals.css`.
- Test coverage: No CSS validation. Manual inspection only.

**Sidebar Brand Block Customization:**
- Files: `references/layout-patterns.md` (lines 206-216), `patterns.md` (line 53), `SKILL.md` (line 53)
- Why fragile: The brand block is documented as mandatory with specific dimensions (h-8 w-8, bg-aries-primary, white ram emoji) but these are hardcoded in component examples. If a user tries to change logo size, they must edit the component — there's no configuration system.
- Safe modification: Users should only modify the text label in the SidebarHeader, not the logo block itself. If logo needs to change (e.g., different emoji, different color), the `app-sidebar.tsx` file needs manual edits.
- Test coverage: No automated validation that brand block renders correctly.

## Scaling Limits

**Single Reference Architecture:**
- Current capacity: Aries assumes one app shell, one sidebar style, one navigation pattern
- Limit: If a user needs multiple layout types (e.g., marketing site sidebar + dashboard sidebar), the patterns don't provide guidance. Documentation assumes all Aries apps follow the same layout.
- Scaling path: Document a "Layout Variants" section covering: narrow sidebars for detail pages, full-width layouts for marketing content, etc. Provide component examples for each.

**Component Baseline Inflexibility:**
- Current capacity: 27 baseline components pre-selected in `components.md`
- Limit: If a project needs a component not in the baseline (calendar, carousel, chart), users must know to install it separately. No guidance on dependency management or conflicts.
- Scaling path: Add a "Components Dependency Matrix" showing which additional components work well together and which might conflict.

## Missing Critical Features

**No Automated Verification of Aries Compliance:**
- Problem: No way to verify a newly scaffolded project actually follows Aries standards. A user could copy the app shell code but forget the theme, resulting in a broken-looking app that claims to be Aries.
- Blocks: Quality assurance, consistent user experience across all Aries projects
- Recommendation: Add a `verify-aries.sh` script that checks:
  - globals.css contains all six Aries color tokens
  - Inter font is loaded in root layout
  - Sidebar component exists and uses correct brand block
  - No arbitrary Tailwind values in component files

**No Upgrade Path for Existing Projects:**
- Problem: If a user scaffolded an Aries project 6 months ago and Aries guidelines have since changed, there's no documented way to apply those changes to their existing project.
- Blocks: Long-term maintenance, keeping projects in sync with latest patterns
- Recommendation: Document an "Update Aries Project" workflow covering: updating theme file, refreshing components, adopting new layout patterns.

**No Dark Mode Support Documentation:**
- Problem: SKILL.md (line 59) states "light mode only" and that the `.dark` block in globals.css "exists for shadcn component compatibility only", but some shadcn components may render differently in dark mode. No guidance on how to handle this.
- Blocks: Projects that need dark mode cannot safely use Aries
- Recommendation: Either fully support dark mode with Aries colors, or add a clear statement that Aries projects cannot support dark mode (and disable the `.dark` block).

## Test Coverage Gaps

**No Layout Template Tests:**
- What's not tested: The HeaderBreadcrumb auto-generation logic, sidebar responsive behavior, header sticky positioning
- Files: `references/layout-patterns.md` (all code examples are untested)
- Risk: Subtle bugs in breadcrumb generation or responsive behavior could ship to users
- Priority: High — layout is the most visible part of every Aries project

**No Theme Verification Tests:**
- What's not tested: That globals.css contains all required tokens, that color values match brand specs, that typography utilities render correctly
- Files: `theme/globals.css`
- Risk: Silent failures where colors don't match brand or fonts render incorrectly
- Priority: High — these are foundational to the entire design system

**No Installer Robustness Tests:**
- What's not tested: Behavior when git or Node.js is missing, network failures during clone, corrupt Bash/PowerShell execution
- Files: `scripts/install.sh`, `scripts/install.ps1`
- Risk: Installation failures with unclear error messages, leaving users stuck
- Priority: Medium — affects first-time user experience

## Security Considerations

**No Signature Verification on Downloaded Code:**
- Risk: `scripts/install.sh` and `scripts/install.ps1` clone the skill repo without verifying GPG signatures or commit hashes. An attacker could perform MITM or DNS poisoning to serve malicious code.
- Files: `scripts/install.sh` (line 101), `scripts/install.ps1` (line 160)
- Current mitigation: Code is hosted on GitHub which has some security, but no cryptographic verification.
- Recommendations:
  1. Document that users should verify the HTTPS certificate
  2. Consider adding commit hash verification or signed releases
  3. Add a checksum file that verifies downloaded code matches expected content

**Installer Creates User-Writable Directories:**
- Risk: `scripts/install.sh` (lines 89, 93) and `scripts/install.ps1` (line 145) create `.claude/skills/` with user write access. If .claude directory is world-readable, another user on shared system could modify it.
- Files: `scripts/install.sh`, `scripts/install.ps1`
- Current mitigation: Standard umask during install should apply 755/644 permissions
- Recommendations: Document that users should verify directory permissions after install: `ls -ld ~/.claude/skills/`

**No Input Validation on App Names:**
- Risk: Sidebar brand block uses user-supplied app name without sanitization. If a user passes a name with special characters or HTML, it might break rendering.
- Files: `references/layout-patterns.md` (line 214), `references/scaffold.md` — app names are passed as string templates
- Current mitigation: React/JSX automatically escapes values, so XSS is not a risk. But very long names could break layout.
- Recommendations: Document that app names should be reasonable length (under 20 chars recommended). Add a note about special character handling.

---

*Concerns audit: 2026-03-20*
