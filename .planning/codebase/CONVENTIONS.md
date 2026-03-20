# Coding Conventions

**Analysis Date:** 2026-03-20

## Naming Patterns

**Files:**
- Module files use `.cjs` extension (CommonJS): `core.cjs`, `phase.cjs`, `state.cjs`
- Hook scripts use `.js` extension: `gsd-check-update.js`, `gsd-statusline.js`, `gsd-context-monitor.js`
- Markdown documentation follows uppercase pattern: `ROADMAP.md`, `STATE.md`, `PLAN.md`, `SUMMARY.md`

**Functions:**
- Command functions prefixed with `cmd`: `cmdPhasesList()`, `cmdFindPhase()`, `cmdStateLoad()`
- Internal/private utilities have no prefix: `escapeRegex()`, `normalizePhaseName()`, `toPosixPath()`
- State field extraction functions prefixed with `state`: `stateExtractField()`, `stateReplaceField()`
- Template building functions prefixed with `build`: `buildStateFrontmatter()`

**Variables:**
- camelCase for local variables and parameters: `currentPhase`, `phaseNumber`, `phaseName`
- SCREAMING_SNAKE_CASE for constants: `MODEL_PROFILES`, `AUTO_COMPACT_BUFFER_PCT`
- Descriptive names for regex patterns: `phasePattern`, `boldPattern`, `checkboxPattern`
- Underscore suffix for normalized/processed versions: `normalized`, `escaped`, `unpadded`

**Types:**
- Object keys use snake_case: `phase_number`, `phase_name`, `phase_slug`, `is_last_phase`
- Frontmatter/JSON fields use snake_case: `gsd_state_version`, `current_phase`, `files_modified`
- Boolean fields end with `_is` or use adjective form: `has_summary`, `autonomous`, `found`

## Code Style

**Formatting:**
- No explicit formatter configured (no .prettierrc, eslint config found in root)
- Consistent indentation: 2 spaces
- Comments use `//` for inline, `/** ... */` for block JSDoc-style
- Long comment headers use visual separators: `// ─── Section Name ─────────────────────────────────────`
- Line length: typically 100 columns, exceptions for long paths or regex

**Linting:**
- No linter configured; code follows Node.js/JavaScript best practices informally
- Error handling uses try-catch blocks extensively
- Silent failure patterns common: `catch {}` or `catch (e) {}`

## Import Organization

**Order:**
1. Built-in Node modules: `require('fs')`, `require('path')`, `require('child_process')`
2. Local modules: `require('./core.cjs')`, `require('./lib/state.cjs')`
3. Destructured imports (same order): built-ins first, then local

**Pattern:**
```javascript
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const { escapeRegex, normalizePhaseName, findPhaseInternal, output, error } = require('./core.cjs');
const { extractFrontmatter } = require('./frontmatter.cjs');
```

**Module exports:**
- Use `module.exports = { ...functions }` at bottom of file
- Batch exports: export multiple related functions as object
- Example: `module.exports = { cmdStateLoad, cmdStateGet, cmdStatePatch, ... };`

## Error Handling

**Patterns:**
- Custom `error(message)` function in `core.cjs` for fatal errors (exits with code 1)
- `safeReadFile(filePath)` returns `null` on failure, doesn't throw
- Silent catch blocks: `catch {}` or `catch (e) {}` for non-critical operations
- Two-level error responses: explicit errors for missing required args, silent returns for missing files

**Example:**
```javascript
function cmdPhaseAdd(cwd, description, raw) {
  if (!description) {
    error('description required for phase add');  // Fatal: exits
  }

  const roadmapPath = path.join(cwd, '.planning', 'ROADMAP.md');
  if (!fs.existsSync(roadmapPath)) {
    error('ROADMAP.md not found');  // Fatal: exits
  }

  try {
    // operations
  } catch {
    // Silent fail or output error object
  }
}
```

## Logging

**Framework:** `console` (no dedicated logging library)

**Output patterns:**
- `output(result, raw, rawValue)` - structured output function in `core.cjs`
- For `--raw` flag: return plain text value (rawValue)
- For JSON: return object; large payloads (>50KB) written to tmpfile with `@file:` prefix
- `process.stderr.write()` for errors via `error()` function
- `process.stdout.write()` for explicit output

**When to log:**
- Entry/exit of major operations (phase operations, state updates)
- Data transformation milestones (parsing ROADMAP, extracting frontmatter)
- File operations results (created, updated, deleted)
- Not: internal utility calls, successful silent operations

## Comments

**When to Comment:**
- Complex regex patterns: explain what they match
- Subtle behavior or edge cases: explain the "why"
- Non-obvious state management: explain data flow
- Workarounds: explain the problem being worked around

**Examples:**
```javascript
// --no-index checks .gitignore rules regardless of whether the file is tracked.
// Without it, git check-ignore returns "not ignored" for tracked files even when
// .gitignore explicitly lists them — a common source of confusion when .planning/
// was committed before being added to .gitignore.
execSync('git check-ignore -q --no-index -- ' + targetPath, { cwd, stdio: 'pipe' });

// Segment-by-segment decimal comparison: 12A < 12A.1 < 12A.1.2 < 12A.2
const aDecParts = pa[3] ? pa[3].slice(1).split('.').map(p => parseInt(p, 10)) : [];
```

**JSDoc/TSDoc:**
- Block comments over functions document parameters and return
- Not exhaustive; optional for short/obvious functions
- Format: `/** Description. */` or multiline with `@param` tags

**Example:**
```javascript
/**
 * Returns a filter function that checks whether a phase directory belongs
 * to the current milestone based on ROADMAP.md phase headings.
 * If no ROADMAP exists or no phases are listed, returns a pass-all filter.
 */
function getMilestonePhaseFilter(cwd) { ... }
```

## Function Design

**Size:**
- Typically 20-150 lines per function
- Larger functions (phase operations, verification) accepted for cohesion
- Maximum nesting depth: 3-4 levels

**Parameters:**
- 2-4 parameters typical
- Extra parameters bundled in `options` object for command handlers
- Example: `cmdPhaseRemove(cwd, targetPhase, options, raw)`

**Return Values:**
- CLI commands return `undefined`; output via `output()` function
- Utility functions return values directly
- Null for not-found cases (prefer over throwing)
- Objects for structured returns: `{ found: true, directory: '...', phase_number: '...' }`

## Module Design

**Exports:**
- Each `.cjs` file is single-purpose module: `core.cjs` (utilities), `phase.cjs` (phase operations), `state.cjs` (state management)
- Batch export of related functions at module bottom
- No default export; use named exports only

**Barrel Files:**
- Not used; direct imports from specific modules

**Organization:**
- Group related functions with visual separators: `// ─── Section Name ────────────────────────────────────`
- Utilities at top of file, public commands at bottom
- All exports listed at bottom in `module.exports`

**Patterns:**
- Stateless functions: operations pure, no module-level state mutations
- Dependency injection: pass `cwd` as parameter, not global
- Immutable defaults: `const defaults = { ... }` then merge with provided config

## Filename/Phase Numbering

**Phase directory naming:**
- Format: `DD-slug` or `DD.d-slug` where DD is zero-padded integer
- Example: `01-initial-setup`, `06.2-dynamic-feature`
- Slug derived from phase description: lowercase, hyphens for spaces

**Plan/Summary file naming:**
- Format: `PHASE-PLAN.md` or `PHASE-PLAN-ID.md` (e.g., `06-01-PLAN.md` or `06-01-PLAN.md`)
- Summaries follow same convention: `06-01-SUMMARY.md`
- Legacy support: plain `PLAN.md` and `SUMMARY.md` in phase directory

## State and Config Files

**STATE.md structure:**
- YAML frontmatter header with machine-readable fields
- Markdown body with human-readable sections
- Fields: Current Phase, Current Plan, Status, Progress, Last Activity, Decisions, Blockers

**ROADMAP.md structure:**
- Phase sections with `##` or `###` headers
- Format: `## Phase N: Description` followed by details
- Checkbox list for completion tracking: `- [x] Phase 5: ...`
- Optional progress table for phases

**.planning/config.json structure:**
- Top-level keys: `model_profile`, `branching_strategy`, `commit_docs`, `research`, `plan_checker`, `verifier`
- Nested sections: `git: { branching_strategy, phase_branch_template }`
- Defaults applied if keys missing

---

*Convention analysis: 2026-03-20*
