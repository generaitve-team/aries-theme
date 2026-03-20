# Testing Patterns

**Analysis Date:** 2026-03-20

## Test Framework

**Status:** No test framework currently configured

**Note:** This codebase is a CLI tool (GSD - Get Shit Done) that manipulates filesystem state and Git operations. No Jest, Vitest, Mocha, or other test runner is present. Testing appears to be manual/integration-based rather than automated unit tests.

**Runner:**
- Not configured; no test script in package.json found
- Manual verification via CLI invocation
- Integration testing via actual project state changes

**Assertion Library:**
- Not used; no unit tests present
- Verification done through output inspection and filesystem state checks

**Run Commands:**
```bash
# No automated test commands configured
# Manual testing approach: run gsd-tools.cjs commands and inspect results
node ./.claude/get-shit-done/bin/gsd-tools.cjs <command> [args]
```

## Test File Organization

**Location:**
- No dedicated test directory found
- No `__tests__`, `tests/`, or `.test.js` files in codebase

**Naming:**
- N/A (no test files present)

**Structure:**
- N/A (no test framework)

## Manual Testing / Verification Patterns

### Command Verification Approach

The codebase uses **manual verification commands** in lieu of automated tests. Critical operations are verified through:

**1. CLI Commands as Self-Tests:**

Located in `verify.cjs`, various validation commands check codebase state:

```javascript
// From verify.cjs - Validates PLAN.md structure
cmdVerifyPlanStructure(cwd, planPath, raw) {
  // Checks:
  // - Frontmatter present and valid
  // - Task count (XML <task> tags or ## Task N markdown)
  // - Required fields: objective, wave, files_modified
  // - Output structure validation
}

// From verify.cjs - Validates phase completeness
cmdVerifyPhaseCompleteness(cwd, phase, raw) {
  // Checks:
  // - All PLAN.md files have matching SUMMARY.md files
  // - Incomplete plans identified
  // - Wave organization validated
}

// From verify.cjs - Validates references
cmdVerifyReferences(cwd, planPath, raw) {
  // Checks:
  // - @-references resolve to existing files
  // - File paths in frontmatter exist
  // - Backward compatibility with legacy formats
}
```

**2. State Consistency Validation:**

```javascript
// From verify.cjs - Validates overall consistency
cmdValidateConsistency(cwd, raw) {
  // Checks:
  // - Phase numbering correctness
  // - Filesystem state matches ROADMAP.md
  // - No gaps in phase sequences
  // - Decimal phase organization valid
}
```

**3. Health Checks:**

```javascript
// From verify.cjs - Full health audit with repair option
cmdValidateHealth(cwd, options, raw) {
  // Checks:
  // - .planning/ directory structure complete
  // - ROADMAP.md, STATE.md, config.json present
  // - Phase directories named correctly
  // - Can optionally repair issues:
  //   - Create missing directories
  //   - Fix invalid phase naming
  //   - Regenerate STATE.md if missing
}
```

## Output Validation Patterns

### Example: Phase List Verification

```javascript
// From phase.cjs - cmdPhasesList
// Returns structured JSON that calling code can validate:
{
  "directories": ["01-initial-setup", "02-core-features", "03-polish"],
  "count": 3
}

// Or with --raw flag:
// Plain text: 01-initial-setup\n02-core-features\n03-polish
```

### Example: Find Phase Verification

```javascript
// From phase.cjs - cmdFindPhase
// Returns:
{
  "found": true,
  "directory": ".planning/phases/06-dynamic-feature",
  "phase_number": "06",
  "phase_name": "dynamic-feature",
  "plans": ["06-01-PLAN.md", "06-02-PLAN.md"],
  "summaries": ["06-01-SUMMARY.md"]
}
```

Calling code validates:
- `found === true` means phase exists
- `plans.length === summaries.length` means phase is complete
- `directory` path is accessible

### Example: State Snapshot Verification

```javascript
// From state.cjs - cmdStateSnapshot
// Returns parseable structure:
{
  "current_phase": "06",
  "current_plan": 2,
  "status": "executing",
  "progress_percent": 67,
  "decisions": [...],
  "blockers": [...]
}
```

Callers verify:
- `status` is in expected state
- `progress_percent` is incrementing
- `blockers.length > 0` indicates issues needing resolution

## Mocking / Fixtures

**Framework:** None configured

**File System Mocking:**
- Codebase assumes real filesystem operations
- No fs mocking library (sinon, jest.mock) used
- All tests are integration-level, working with actual files

**Approach for Testing (if needed):**
- Create temporary `.planning/` directory structure
- Run CLI commands against temp directory
- Inspect resulting files and state
- Clean up temp directory

**Example test pattern (pseudo-code):**
```javascript
// Hypothetical test structure (not present in codebase)
const fs = require('fs');
const path = require('path');
const os = require('os');

function testPhaseAdd() {
  // Create temp project
  const tmpDir = path.join(os.tmpdir(), 'gsd-test-' + Date.now());
  fs.mkdirSync(path.join(tmpDir, '.planning', 'phases'), { recursive: true });

  // Create minimal ROADMAP.md
  fs.writeFileSync(
    path.join(tmpDir, '.planning', 'ROADMAP.md'),
    '## Phase 1: Setup\n\n**Goal:** Bootstrap\n'
  );

  // Run phase add command
  // const result = cmdPhaseAdd(tmpDir, 'New feature', false);

  // Verify output
  // assert(result.phase_number === 2);
  // assert(fs.existsSync(path.join(tmpDir, '.planning', 'phases', '02-new-feature')));

  // Cleanup
  // fs.rmSync(tmpDir, { recursive: true });
}
```

## Test Types

**Unit Tests:**
- Not present
- Core utilities (`normalizePhaseName()`, `comparePhaseNum()`, `escapeRegex()`) could be unit tested
- Would validate phase numbering logic, regex patterns, path normalization

**Integration Tests:**
- Not formalized but operations are integrated
- Testing requires full `.planning/` directory structure
- Commands like `phase remove` perform cascading updates (ROADMAP.md, file renames, STATE.md updates)
- Each command tests multiple modules working together

**E2E Tests:**
- Not automated
- Manual verification: human runs full workflow and validates end state
- Example: Execute complete phase planning → execution → verification cycle
- Manual check: ROADMAP.md reflects reality, STATE.md accurate, phase directories correct

**Snapshot Testing Pattern (could be applied):**
- ROADMAP.md and STATE.md serve as quasi-snapshots
- After phase operations, verify markdown files reflect expected structure
- Compare before/after state when removing phases (lots of renumbering)

## Frontmatter Validation

**Framework:** Custom validation in `frontmatter.cjs` and `verify.cjs`

**Patterns:**

```javascript
// From verify.cjs - Validates PLAN.md frontmatter
const requiredPlanFields = ['phase', 'plan', 'wave', 'objective', 'files_modified'];

for (const field of requiredPlanFields) {
  if (!frontmatter[field]) {
    errors.push(`Missing required field: ${field}`);
  }
}

// Type checking for specific fields
if (typeof frontmatter.autonomous !== 'boolean' && frontmatter.autonomous !== undefined) {
  errors.push('autonomous must be boolean');
}

// Array validation
if (frontmatter.files_modified && !Array.isArray(frontmatter.files_modified)) {
  errors.push('files_modified must be array');
}
```

**PLAN.md Required Fields (from code):**
- `phase` - Phase number (e.g., "06")
- `plan` - Plan ID within phase (e.g., "01")
- `wave` - Wave number for parallelization
- `objective` - What this plan accomplishes
- `files_modified` - Array of files changed
- `autonomous` - Boolean, can execute without checkpoints

**SUMMARY.md Required Fields (from code):**
- `phase` - Phase number completed
- `plan` - Plan ID completed
- `status` - Execution result (success/partial/blocked)
- `duration` - Time spent
- `work_summary` - What was done
- `commits` - Git commit hashes for traceability

## Field Extraction Patterns

```javascript
// From frontmatter.cjs - Extract typed field
function getField(fm, key, type) {
  if (type === 'array' && !Array.isArray(fm[key])) {
    return Array.isArray(fm[key]) ? fm[key] : fm[key] ? [fm[key]] : [];
  }
  if (type === 'boolean') {
    return fm[key] === true || fm[key] === 'true';
  }
  if (type === 'integer') {
    return parseInt(fm[key], 10);
  }
  return fm[key];
}

// Usage in phase indexing
const wave = parseInt(fm.wave, 10) || 1;  // Default to 1 if missing
const autonomous = fm.autonomous === 'true' || fm.autonomous === true;
const filesModified = Array.isArray(fmFiles) ? fmFiles : [fmFiles];
```

## Common Patterns

### Async Testing

**Not applicable:** Codebase is synchronous Node.js (uses `execSync` for Git, not async patterns)

### Error Testing

**Patterns:**

Commands test error conditions through return objects:

```javascript
// From phase.cjs - cmdFindPhase
// Returns error-like structure instead of throwing
if (!match) {
  output(notFound, raw, '');  // notFound = { found: false, directory: null, ... }
  return;
}
```

**Test approach (if formalized):**
```javascript
// Hypothetical error test
const result = cmdFindPhase(tmpDir, 'nonexistent-phase', false);
assert(result.found === false);
assert(result.error === 'Phase not found');
```

### State Mutation Testing

Commands that modify state return both result and verification:

```javascript
// From phase.cjs - cmdPhaseAdd
const result = {
  phase_number: newPhaseNum,
  directory: `.planning/phases/${dirName}`,
  roadmap_updated: true  // Indicates successful update
};

// Test would verify:
// 1. Directory created: fs.existsSync(dirPath)
// 2. ROADMAP.md updated: content includes phase
// 3. Return object accurate: result.phase_number matches actual
```

### Renumbering Validation

Most complex test case: phase removal triggers cascading updates:

```javascript
// From phase.cjs - cmdPhaseRemove
// Updates:
// 1. Delete target directory
// 2. Renumber all subsequent phase directories
// 3. Rename plan/summary files inside renamed directories
// 4. Update all references in ROADMAP.md
// 5. Update STATE.md counts

// Test would need to:
// 1. Create phases 01, 02, 03, 04
// 2. Remove phase 02
// 3. Verify:
//    - Phase 02 directory deleted
//    - Phase 03 renamed to 02
//    - Phase 04 renamed to 03
//    - ROADMAP.md references updated (3 occurrences of "02")
//    - STATE.md total phases decremented
```

## Coverage

**Requirements:** None enforced

**Current State:** No coverage metrics tracked

**Recommended approach (if implementing tests):**
- Unit test utilities: `normalizePhaseName()`, `comparePhaseNum()`, regex functions
- Integration test each command in `gsd-tools.cjs`
- E2E test full workflows (new project → plan phases → execute → complete milestone)
- Target: 70%+ coverage for core logic, 100% for phase numbering (most critical)

## Absence of Automated Tests

**Why no tests?**

1. **Filesystem state centric:** Operations mutate .planning/ directory and Git repos — hard to test without real filesystem
2. **CLI tool:** Commands invoked via CLI, outputs validated manually
3. **Mature usage:** GSD framework is stable; changes rare and high-risk
4. **Integration heavy:** Most operations require multiple modules working together (phase.cjs → state.cjs → roadmap.cjs)

**Risk mitigation (current approach):**

1. **Verification commands:** `gsd-tools verify *` commands validate state
2. **Manual testing workflow:** Run GSD commands on test projects, inspect state
3. **Conservative change policy:** Major refactors have external review
4. **Git history:** Can rollback bad state changes via Git

---

*Testing analysis: 2026-03-20*
