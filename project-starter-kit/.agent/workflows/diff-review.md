---
description: Review the current diff against codebase standards before committing. Lighter than /pre-push.
---

# Diff Review

**When to use:** Before committing. Quick architectural scan of your changes.

**Core principle:** Linters catch syntax. This catches design violations.

---

## Step 1: Get the Diff

```bash
# Staged changes (about to commit)
git diff --cached --unified=3

# Or all changes (staged + unstaged)
git diff --unified=3
```

---

## Step 2: Scan Each Changed File

For every file in the diff:

### Structure
- [ ] File stays within size limits (Service ≤ 500, Repo ≤ 800, Utility ≤ 200)
- [ ] New public methods have corresponding test coverage
- [ ] No temporal coupling introduced (caller must call A then B)

### Types
- [ ] No `any` types
- [ ] No unsafe `as` casts
- [ ] Error channels specified on Effect types

### Imports
- [ ] All paths resolve with correct extensions
- [ ] Boundary rules respected
- [ ] No unused imports added

### Security
- [ ] No hardcoded secrets
- [ ] No unvalidated external input

### Hygiene
- [ ] No debug `console.log`
- [ ] No commented-out code
- [ ] Guard clauses at top, happy path flows down

---

## Step 3: Verdict

| Level | Meaning |
|-------|---------|
| **BLOCK** | Must fix — type safety, security, boundary violation |
| **WARN** | Should fix — hygiene, style, missing tests |
| **PASS** | Clean — ready to commit |

For BLOCK issues, offer to fix automatically.
