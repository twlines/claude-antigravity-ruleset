# AI Rules

Universal engineering rules for AI-assisted development. Works with both **Claude Code** (`~/.claude/`) and **Antigravity** (`~/.gemini/`).

## Quick Start

```bash
git clone git@github.com:trevorlines/ai-rules.git ~/ai-rules
cd ~/ai-rules
./install.sh
```

## What's Included

### Global Rules (Machine-Level)

Applied to every project on this machine, regardless of repo.

| File                          | Purpose                         | Symlinked To                        |
| ----------------------------- | ------------------------------- | ----------------------------------- |
| `global/engineering-rules.md` | Universal engineering standards | `~/.claude/build-it-right-rules.md` |
| `global/gemini-global.md`     | Antigravity global config       | `~/.gemini/GEMINI.md`               |

### Project Starter Kit (Repo-Level)

Template files you copy into new projects. Both Claude Code and Antigravity read these from the workspace.

```
project-starter-kit/
├── CLAUDE.md                          ← Claude Code project config
└── .agent/
    ├── rules/
    │   ├── architecture.mdc           ← Size limits, deep modules
    │   ├── coding-standards.mdc       ← Style, Golden Snippet
    │   ├── documentation.mdc          ← DESIGN INTENT, JSDoc
    │   └── process.mdc               ← TDD, verification loop
    └── workflows/
        ├── verify.md                  ← /verify command (after every file change)
        ├── deep-research.md           ← /deep-research command (before implementation plans)
        ├── pre-push.md                ← /pre-push command (before every git push)
        └── diff-review.md             ← /diff-review command (before committing)
```

## Usage

### New Machine Setup

```bash
git clone git@github.com:trevorlines/ai-rules.git ~/ai-rules
cd ~/ai-rules
./install.sh
```

### Update Rules (Any Machine)

```bash
cd ~/ai-rules && git pull
```

That's it. Symlinks mean changes propagate instantly.

### Start a New Project

```bash
cd ~/ai-rules
./new-project.sh /path/to/your/new/project
```

This copies the starter kit into the project directory and reminds you to customize `[CUSTOMIZE]` markers.

## Architecture

```
install.sh creates symlinks:
  global/engineering-rules.md  →  ~/.claude/build-it-right-rules.md
  global/gemini-global.md      →  ~/.gemini/GEMINI.md

new-project.sh copies (not symlinks) into your project:
  project-starter-kit/*  →  /path/to/project/
```

**Why symlinks for global, copies for projects?**

- Global rules: one source of truth, `git pull` updates everywhere
- Project rules: committed to each project's repo, customized per project via `[CUSTOMIZE]` markers
