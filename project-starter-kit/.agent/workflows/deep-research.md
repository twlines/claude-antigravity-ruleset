---
description: Multi-pass deep research loop before any implementation plan is finalized.
---

# Deep Research Protocol

**When to use:** Any task requiring an implementation plan — features spanning 3+ files, pipeline wiring, refactors, or cross-boundary changes.

**Core principle:** The first plan is always a first draft. All passes must complete before a plan is "ready for execution."

---

## Pass 1: Forward Trace

**Lens:** "What does this code do today?"

1. Trace the entry point (user action, API call, or trigger)
2. Follow every function call — read each file, note exact lines
3. Document the data shape at each boundary
4. Map the dependency chain
5. Identify the exit point (where the result surfaces to the user)

**Output:** A trace with a flow diagram, every file involved, and data transformations at each step.

---

## Pass 2: Inventory Audit

**Lens:** "What did I miss? What's built but not wired?"

1. Search for siblings (if you found `FooDisk.ts`, search `*Disk*` in the same directory)
2. Search for parallel pipelines or services you didn't trace
3. Check reference documents, READMEs, design docs in relevant directories
4. Cross-reference: is there a newer/better version of something that exists but isn't used?
5. Re-read the original request — did you answer everything or just a subset?

**Output:** Inventory table: Component | Exists? | Wired? | Status

---

## Pass 3: Interface Contract Validation

**Lens:** "Even if each piece works internally, do they fit together?"

1. Schema alignment — compare field names, types, casing between sender and receiver
2. Response envelope — does the client expect flat data or a wrapper?
3. Auth flow — trace token from storage → header → middleware → handler
4. Import resolution — can the importing package actually resolve the path?
5. Environment variables — list every env var. Are they set in deployment?

**Output:** Bug table: Bug # | Description | File:Line | Evidence

---

## Pass 4: Adversarial Audit

**Lens:** "I'm trying to break this. What fails?"

1. Timeout analysis — sequential async ops × expected latency vs deployment limits
2. Memory analysis — large responses, multiple in-flight requests
3. Concurrency/race conditions — double-clicks, shared mutable state
4. Error path audit — for every `try/catch`, what does the user see when it fails?
5. Edge cases — empty inputs, very long inputs, missing optional fields
6. Dual-path analysis — when code has two paths (feature flag, A/B), trace what the INACTIVE path does

**Output:** Risk assessment with CRITICAL / MODERATE / LOW ratings.

---

## Pass 5: Expert Persona Audit

**Lens:** "What would a world-class specialist catch?"

1. Pick 1-3 expert personas relevant to the task's risks
2. Prompt: "Find exactly 3 critical flaws from your perspective. Ignore generic advice."
3. Integrate valid feedback into the plan

---

## Pass 6: Plan Stress Test

**Lens:** "If I execute this plan exactly as written, will it work?"

1. Simulate execution — walk through each proposed change. Does it compile after each step?
2. Dependency ordering — can Phase 1 deploy independently?
3. Verification feasibility — can the test commands actually run?
4. Missing steps — one-time setup, env vars, credential entries?
5. Scope creep — is the plan doing more than necessary?

---

## Rules

- Done when Pass 6 produces no changes
- If Pass 4-6 reveals fundamental issues, loop back to the relevant pass
- Maximum 7 passes before presenting to user
- Every pass updates the same artifacts (don't create new files per pass)

## Anti-Patterns

- ❌ Assuming imports resolve without checking exports/barrel files
- ❌ Presenting Pass 1 output as a finished plan
- ❌ Skipping Pass 2 (the biggest finds happen here)
- ❌ Only tracing the active code path — inactive paths leak errors
- ❌ Reading only files you expect to be relevant — search broadly first
