# Engineering Rules

**Read on every session. Violations are blocking.**

---

## Protocols

**Plan first.** For tasks spanning 3+ files, run `/deep-research` before writing an implementation plan. The first plan is always a draft.

**Read before write.** `view_file` directory contents and adjacent files before creating any new file. Verify exports exist before importing them.

**Test before code.** Write the test file before the production file. Tests import directly from the module, not through facades.

**Verify after every change.** Run `/verify` — compile, test, audit, regression. Any fix restarts the loop from compile. "I wrote the file" is not done.

---

## Architecture

- **500-line limit** for services, **800** for repositories, **400** for facades, **200** for utilities. Hit the limit → decompose now.
- **Deep modules.** Every public method hides ≥3× its interface complexity. Simple interface, significant implementation.
- **No temporal coupling.** If callers must invoke methods in sequence, wrap the sequence into one method.
- **Directory-per-domain.** Organize by responsibility, not data source.
- **Extraction order:** Types → Repository → Independent services → Dependent services → Facade → Legacy facade (1 release).

## Style

- **Guard clauses first.** Happy path flows straight down, no deep nesting.
- **Max 4 parameters.** Beyond 4 → options object.
- **Rich return types.** Return `{ total, created, skipped }` not `number`.
- **`const` by default.** `let` only for accumulation. Never `var`.
- **Exhaustive switch.** `never` check in default case.
- **No `any`.** Use `unknown` + validation (Zod). Validate at boundaries.
- **No side effects on import.** Defer to `init()` or usage time.
- **No commented-out code.** Delete it. Git remembers.

## Error Handling

- **Degrade gracefully.** Non-critical ops (notifications, analytics) never crash the main operation.
- **Coalesce errors.** One result type with `success`, `retryable`, `reason`.
- **Log-and-continue** for auxiliary failures.

## Casing

- `snake_case` at storage/API boundaries
- `camelCase` in-process TypeScript
- Schemas preprocess to canonical shape

## Documentation

Every source file:

- Module doc comment with **DESIGN INTENT** (why it exists, what it hides)
- `@see` links to relevant plan/design docs
- JSDoc on all exported functions (`@param`, `@returns`, `@throws`)
- Section separators: `─── Imports ───`, `─── Types ───`, `─── Service ───`

## Subagent Delegation

When delegating to subagents:

- **One clear goal** per subagent with defined inputs and expected outputs.
- **Include all context** — subagents don't inherit your conversation.
- **Specify exit condition** — what does "done" look like?
- **Verify output** against these same rules before accepting.

## Process

- **Boy Scout Rule.** Every file you touch: zero lint/type errors after, including pre-existing ones.
- **API integration.** Trace the complete path (Client → Endpoint → Handler → Storage) before integrating.
- **Queue-driven execution.** For large-scale work, use a queue file — one item per cycle, update status, persist across sessions.
- **Remediation over restart.** Inject corrections into existing conversations rather than re-explaining from scratch.

## Anti-Patterns (NEVER)

- ❌ Skip TDD for "simple" code
- ❌ Label test failures "pre-existing" without investigating
- ❌ Present a forward-trace as a finished plan
- ❌ Exit verification loop after a fix without restarting from compile
- ❌ Trace only the active code path — inactive paths leak errors
- ❌ Assume imports resolve without checking
- ❌ Comment out dead code instead of deleting it
