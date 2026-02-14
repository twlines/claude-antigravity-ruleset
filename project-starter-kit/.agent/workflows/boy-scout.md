---
description: Boy Scout Rule cleanup pass. Run after /verify passes to leave every touched file better than you found it.
---

# Boy Scout Rule Pass

**When to use:** After `/verify` passes cleanly. This pass looks for **improvement opportunities** — things that aren't broken but could be better. `/verify` checks correctness; `/boy-scout` checks craftsmanship.

**Core principle:** Leave every file you touch better than you found it.

---

## Step 1: Enumerate Touched Files

List every file created or modified in this session.

```bash
# turbo
git diff --name-only HEAD 2>/dev/null; git diff --name-only --cached HEAD 2>/dev/null
```

---

## Step 2: Dead Code Scan

For each touched source file:

```bash
# turbo
grep -nE "^import " <file>
```

- [ ] No unused imports
- [ ] No commented-out code blocks (>3 lines)
- [ ] No TODO/FIXME without a linked task or issue
- [ ] No orphaned `eslint-disable` comments (the thing they disable was already fixed)

---

## Step 3: Blank Line Scars

- [ ] No runs of 3+ blank lines (indicates sloppy deletion)
- [ ] No trailing whitespace on lines you touched

---

## Step 4: Type Hygiene

```bash
# turbo
grep -nE ": any\b|as any\b" <file>
```

For each `any` found:

- [ ] If **new** (introduced by you): Replace with a proper type. No exceptions.
- [ ] If **pre-existing**: Can you narrow it in ≤5 lines? Do it. Otherwise note it.

**Quick wins:**

- `Record<string, any>` → `Record<string, unknown>`
- `(error: any)` → `(error: unknown)` or `(error: Error)`
- `as any` casts that can use `as SomeInterface` instead

---

## Step 5: File Size Budget

```bash
# turbo
wc -l <file>
```

> [CUSTOMIZE] Adjust limits to your project.

| Category            | Max Lines |
| ------------------- | --------- |
| Repository          | 800       |
| Service             | 500       |
| Facade/Orchestrator | 400       |
| Utility/Helper      | 200       |
| Types               | 150       |

**If over budget:**

- Can you extract a helper module?
- Did your changes push it over, or was it already over?
- If your changes pushed it over: extract what you added.
- If it was already over: extract something small (≤30 min) as a boy scout contribution.

---

## Step 6: Comment Quality

For each touched file:

```bash
# turbo
head -15 <file>
```

- [ ] Module-level JSDoc exists with DESIGN INTENT
- [ ] No rambling "internal monologue" comments (>3 lines of narrative)
- [ ] Comments explain **why**, not **what**
- [ ] No stale comments that contradict the current code

---

## Step 7: Naming & Consistency

Quick scan of names in your changes:

- [ ] Function/variable names match existing codebase conventions
- [ ] Boolean variables use `is`/`has`/`should` prefix
- [ ] No abbreviations that aren't already established
- [ ] Casing consistent with the file's existing style

---

## Step 8: Quick Wins

Look for improvements you can make in ≤5 lines each:

- [ ] Guard clauses instead of nested if/else
- [ ] `const` instead of `let` where value never changes
- [ ] Optional chaining (`?.`) instead of `&&` chains
- [ ] Nullish coalescing (`??`) instead of `|| fallback` for non-boolean values
- [ ] Template literals instead of string concatenation

---

## Step 9: Re-verify

After making any boy scout improvements:

```bash
# [CUSTOMIZE] Replace with your project's type-check command
# turbo
npx tsc --noEmit 2>&1 | grep -E "(error TS|Cannot find)" | head -20
```

```bash
# [CUSTOMIZE] Replace with your project's test command
# turbo
npx jest --testPathPattern='<affected_tests>' --no-coverage 2>&1 | tail -20
```

- [ ] Still compiles clean
- [ ] All tests still pass
- [ ] No regressions introduced by cleanup

---

## Reporting Template

```
BOY SCOUT PASS RESULTS:

Files scanned: N
Improvements made: N
  - [file]: [what you improved] (N lines)

Pre-existing issues noted (not fixed):
  - [file]: [issue] — reason: [too large / out of scope]

Verification: compiles ✅ | tests ✅ (N/N pass)
```

## Anti-Patterns

- ❌ Refactoring things that work fine just because you'd write them differently
- ❌ Reformatting entire files when you only touched a few lines
- ❌ Spending >30 min on a single improvement (it's a separate task)
- ❌ Skipping Step 9 — every cleanup needs re-verification
- ❌ Only scanning the files you remember — use `git diff` to catch everything
