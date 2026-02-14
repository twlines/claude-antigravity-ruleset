---
description: Post-plan miss sweep. Run after finalizing an implementation plan and before switching to EXECUTION mode.
---

# /miss-sweep — Post-Plan Miss Sweep

**When to use:** After finalizing an implementation plan, **before** switching to EXECUTION mode.

**Core principle:** The plan looks complete, but what did it miss? This workflow catches gaps by interrogating the plan against actual code and type definitions.

---

## Pass A: Self-Interrogation

Ask yourself these questions about the plan. For each, either confirm or flag:

1. **Response shapes** — For every API call, have I verified the _exact_ property/method names on the response object? (e.g., `.text()` vs `.text`, `.data.items` vs `.items`)
2. **Constructor signatures** — For every class instantiation, have I verified the constructor accepts the arguments I'm passing?
3. **Intermediate types** — For every value I'm passing between functions, have I verified the type is compatible at both the producer and consumer?
4. **Dynamic imports** — Have I grep'd for `await import(` and `require(` in addition to static `import` statements?
5. **Test mocks** — Have I grep'd for `jest.mock` / `vi.mock` of the module being changed? Mock shapes must match new API.
6. **Type-only imports** — Have I grep'd for `import type` from the old module?
7. **Streaming contracts** — If there's streaming, have I verified: what the iterable yields, whether there's an aggregated response, and how usage metadata is accessed?
8. **Silent failures** — Have I identified any parameter renames where the old key is silently ignored (no error, just wrong behavior)?

---

## Pass B: Type-Level Verification

// turbo

1. **Find the `.d.ts` file** for any new or changed dependency:
   ```bash
   find node_modules/<package> -name '*.d.ts' -maxdepth 3
   ```

// turbo

2. **Grep the type definitions** for every type/interface/class your plan references:

   ```bash
   grep -n 'class YourType\|interface YourType\|declare.*YourType' <path-to-d.ts>
   ```

3. **Read the actual type definition** — don't trust docs alone. `.d.ts` files are the source of truth.

4. **For each function call in the plan**, verify:
   - Parameter name matches the type definition exactly
   - Return type has the properties you're accessing
   - Optional vs required fields — are you handling `undefined`?

---

## Pass C: Exhaustive Grep

// turbo

1. Run a compound regex grep across the entire affected directory for ALL patterns related to the change:

   ```bash
   grep -rnE '<old-import>|<OldClass>|<old-method>|<old-response-pattern>' <dir> --include='*.ts'
   ```

2. Compare every hit against the plan's file list. Any file that appears in grep results but NOT in the plan is a miss.

3. Check for **indirect references** — files that import from a file you're changing (callers may depend on re-exported types).

---

## Pass D: Edge Case Hunting

For each file in the plan, answer:

1. Are there **error handlers** that reference old types?
2. Are there **retry wrappers** that depend on old behavior?
3. Are there **logging statements** that stringify old response shapes?
4. Are there **type assertions** (`as OldType`) that need updating?
5. Are there **conditional checks** like `if (result?.response)` that assume old nesting?

---

## Output

After completing all passes, update the implementation plan's **Bug Table** with any new findings. Each new bug should include:

- Description
- File and line number
- Risk level (CRITICAL / MODERATE / LOW)
- How it would manifest (error? silent failure? wrong data?)

If no misses are found, state "**Miss-sweep clean**" in the plan.
