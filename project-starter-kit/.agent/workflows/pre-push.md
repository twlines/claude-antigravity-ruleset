---
description: Full pre-push QA — diff review + gate check + push readiness verdict. Run before every git push.
---

# Pre-Push QA

**When to use:** Before every `git push`. This is the final gate between your machine and CI.

**Core principle:** `/verify` validates each file change as you go. `/pre-push` validates the entire branch is ready to ship.

---

## Phase 1: Diff Review (Architectural Scan)

Get the full diff against the base branch:

```bash
# [CUSTOMIZE] Replace 'main' with your base branch if different
git diff main...HEAD --stat
git diff main...HEAD --unified=3
```

Scan every changed file for:

### Imports & Boundaries
- [ ] All import paths resolve (check exports exist)
- [ ] No circular dependencies introduced
- [ ] Boundary rules respected (apps/ only imports packages/*, etc.)
- [ ] `import type` used for type-only imports

### Type Safety
- [ ] No `any` types introduced
- [ ] No `as` casts without structural proof
- [ ] No `// @ts-ignore` or `// @ts-expect-error` added

### Security
- [ ] No secrets, tokens, or API keys in code
- [ ] No `console.log` with sensitive data
- [ ] Input validation on new endpoints / handlers

### Hygiene
- [ ] No `console.log` debug statements left in
- [ ] No commented-out code blocks
- [ ] No TODO/FIXME without a linked issue

Categorize findings as:
- **BLOCK** — must fix before push
- **WARN** — should fix, won't block
- **INFO** — informational

---

## Phase 2: Gate Check (Full CI Pipeline)

Run all gates locally. Run all four even if one fails — report the full picture.

```bash
# [CUSTOMIZE] Replace with your project's commands
# Gate 1: Type checking
npm run type-check 2>&1

# Gate 2: Linting
npm run lint 2>&1

# Gate 3: Tests
npm test -- --run 2>&1

# Gate 4: Build
npm run build 2>&1
```

---

## Phase 3: New vs Pre-Existing Failures

If any gate fails, determine whether the failure is **new** or **pre-existing**:

1. Was the failing file modified in this branch? (`git diff main...HEAD --name-only`)
2. If unclear, check if the same failure exists on main:
   ```bash
   git stash && npm test -- --run 2>&1 | grep "FAIL" && git stash pop
   ```
3. Only BLOCK on failures introduced by this branch

---

## Phase 4: Final Report

```
## Pre-Push QA Report

### Diff Review
- Files changed: N
- Lines: +X -Y
- Issues: N BLOCK, N WARN

### Gate Check
| Gate | Status |
|------|--------|
| type-check | PASS/FAIL |
| lint | PASS/FAIL |
| test | PASS/FAIL (N new / M pre-existing) |
| build | PASS/FAIL |

### Verdict: READY TO PUSH / BLOCKED
```

---

## If Blocked

List every blocking issue with file:line. Offer to fix all issues in one pass. After fixing, re-run from Phase 2 to confirm.

## If Ready

Confirm the branch and target:
```
Branch `feat/whatever` is ready to push.
Push with: git push -u origin feat/whatever
```

---

## Anti-Patterns
- ❌ Pushing without running this protocol ("CI will catch it")
- ❌ Marking test failures as "pre-existing" without verifying against main
- ❌ Skipping the diff review because "linting handles it" (linters don't catch architectural violations)
- ❌ Running only tests, not the full 4-gate pipeline
