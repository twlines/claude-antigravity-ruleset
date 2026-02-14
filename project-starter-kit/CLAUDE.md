# [PROJECT NAME] — Claude Configuration

> [CUSTOMIZE] Replace [PROJECT NAME] and fill in all [CUSTOMIZE] sections below.

## Project Overview

<!-- [CUSTOMIZE] 2-3 sentences describing what this project does -->

## Tech Stack

<!-- [CUSTOMIZE] List your tech stack -->

- **Frontend:**
- **Backend:**
- **Database:**
- **Validation:**
- **Testing:**

## Project Structure

<!-- [CUSTOMIZE] Document your directory structure -->

```
src/
├── services/     ← Business logic (directory-per-domain)
├── components/   ← UI components
├── screens/      ← Page-level components
└── utils/        ← Shared utilities
```

## Build & Test Commands

<!-- [CUSTOMIZE] List your actual commands -->

```bash
npm install          # Install dependencies
npm run dev          # Dev server
npm run test         # Run tests
npm run type-check   # Type checking
npm run lint         # Linting
```

## Engineering Standards

This project follows the Build-It-Right engineering standards. See:

- `.agent/rules/architecture.mdc` — Size limits, directory structure, deep modules
- `.agent/rules/coding-standards.mdc` — Style, naming, error handling
- `.agent/rules/documentation.mdc` — DESIGN INTENT, JSDoc, section separators
- `.agent/rules/process.mdc` — TDD, verification loop, research protocol

### Key Workflows

- **`/verify`** — Run after EVERY file change, before reporting done
- **`/deep-research`** — Run before any implementation plan for 3+ file tasks
- **`/pre-push`** — Full QA gate before every `git push` (diff review + all CI gates)
- **`/diff-review`** — Quick architectural scan before committing

## Domain Context

<!-- [CUSTOMIZE] Define your domain terms, compliance requirements, sensitive data rules -->

### Key Terms

<!-- Example:
- **Provider** — The end user of the application
- **Practice** — The organization unit
-->

### Compliance & Security

<!-- [CUSTOMIZE] List any compliance requirements (HIPAA, SOC2, GDPR, etc.) -->
<!-- Example:
- **No PII in logs** — Never log names, emails, or sensitive data
- **Sanitize before logging** — Use sanitizer helpers for free text
-->

## Design System

<!-- [CUSTOMIZE] List your reusable components -->

**Rule:** Always search existing components before building new ones.
