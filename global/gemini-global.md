# Antigravity Global Configuration

**Read on every session. These rules apply to ALL projects.**

## Engineering Standards

Read and follow [engineering-rules.md](engineering-rules.md) — the universal engineering standards.

The rules cover: protocols (plan/read/test/verify-first), architecture (size budgets, deep modules), style (guard clauses, const-default, no-any), error handling, documentation (DESIGN INTENT, JSDoc), subagent delegation, and process (Boy Scout, TDD, verification loop).

## Antigravity-Specific Notes

### Rules System

- **Workspace rules** live in `.agent/rules/*.mdc` — these are loaded automatically based on `globs` in the frontmatter.
- **Workflows** live in `.agent/workflows/*.md` — invoked via slash commands like `/verify`.
- **Skills** live in `.agent/skills/*/SKILL.md` — activated by semantic matching on the `description` field.

### Task Execution

- Use `task_boundary` to communicate progress through the task UI.
- Create `task.md` as a living checklist for complex work.
- Create `implementation_plan.md` during PLANNING mode and get user approval before EXECUTION.
- Create `walkthrough.md` after VERIFICATION to document what was accomplished.

### Browser Subagent

When delegating to the browser subagent:

- Provide a **complete, self-contained task description** — the subagent has no access to your conversation.
- Define a **clear return condition** — what information should it bring back?
- Specify **exactly what to click/type/navigate** — don't assume it knows the UI.

### Key Constraints

- Never run destructive commands without user approval (`SafeToAutoRun: false`).
- Use `view_file` before creating or modifying files (Read-Before-Write protocol).
- Prefer `view_file_outline` as the first step when exploring a new file.
