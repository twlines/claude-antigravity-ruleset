---
description: Mandatory verification loop after every file change. Run BEFORE reporting any work as complete.
---

# Verification Protocol

**When to use:** After EVERY file creation or modification. Not optional.

**Core principle:** "I wrote the file" is not done. "The file compiles, passes tests, and meets all standards" is done.

---

## Step 1: Compilation Gate (BLOCKING)

Every file you touched must compile.

```bash
# [CUSTOMIZE] Replace with your project's type-check command
npx tsc --noEmit 2>&1 | grep -E "(error TS|Cannot find)" | head -20
```

If this fails, STOP. Fix the type error before anything else.

---

## Step 2: Test Execution Gate (BLOCKING)

Run ALL tests in the affected directory — not just the ones you think are relevant.

```bash
# [CUSTOMIZE] Replace with your project's test command
npx jest --testPathPattern='<directory_of_changed_files>/__tests__/' --no-coverage 2>&1 | tail -20
```

Verify in the output:

- [ ] "Test Suites: N passed, N total" — passed == total
- [ ] "Tests: N passed, N total" — passed == total

If any test fails, STOP. Fix it.

---

## Step 3: Completeness Audit (BLOCKING)

For every source file you created or modified:

### 3a. Test File Exists

- [ ] Every `.ts` source file has a corresponding test file
- [ ] Exception: `types.ts`, `index.ts` (barrel), pure type files

### 3b. Documentation

- [ ] Module-level doc comment exists with DESIGN INTENT
- [ ] `@see` links to relevant plan/standard docs

### 3c. Size Limits

- [ ] File is within its category's line limit (Service ≤ 500, Utility ≤ 200, etc.)

### 3d. Method Count

- [ ] Method count is within limit (Service ≤ 8, Facade ≤ 5, etc.)

### 3e. No New `any` Types

- [ ] Zero new `any` types introduced

---

## Step 4: Cross-Reference Audit

Enumerate what you were supposed to deliver vs. what you actually verified:

```
EXPECTED DELIVERABLES:
1. [file name] — [purpose]

VERIFIED DELIVERABLES:
1. [file name] — compiles: ✅ | tests: ✅ | test file exists: ✅ | docs: ✅

MISSING:
- [none, or list what's missing]
```

---

## Step 5: Regression Check

Run the broader module test suite to confirm no pre-existing tests broke.

```bash
# [CUSTOMIZE] Replace with your project's broader test command
npx jest --testPathPattern='<broader_pattern>' --no-coverage
```

- [ ] No pre-existing tests broke
- [ ] Every failure is investigated (not hand-waved as "pre-existing")

---

## The Loop (MANDATORY)

This is a **loop, not a checklist**:

```
After ANY fix at ANY step → RESTART from Step 1
ALL clean (zero issues) → EXIT and report done
Maximum 5 passes
```

## Anti-Patterns

- ❌ "I wrote the test file" without running it
- ❌ "All tests pass" without showing output
- ❌ Running only new tests, not the full suite
- ❌ Assuming compilation because "I didn't introduce errors"
- ❌ Exiting the loop after a fix without restarting from Step 1
- ❌ Skipping Step 4 (cross-reference catches the biggest misses)
