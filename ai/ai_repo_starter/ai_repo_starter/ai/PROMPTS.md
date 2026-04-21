# PROMPTS.md

> Registry and operating guide for reusable prompts in this repo.

---

## PURPOSE OF THIS FILE

Use this file to:
- catalog prompt workflows that matter to the repo
- define when each prompt should be used
- keep reusable agent prompts aligned with the repo context files
- reduce session drift across AI usage

---

## PROMPT USAGE RULES

All reusable prompts should:
- reference repo AI files as source of truth
- distinguish confirmed facts from open questions
- prefer asking questions before deciding
- adapt to project size and maturity
- avoid assuming files exist when they do not
- output clear, structured deliverables

---

## ACTIVE PROMPT PACKS

### `prompts/claude-session-kickoff.md`
Use when starting or resuming work with Claude.

### `prompts/feature-implementation.md`
Use when implementing a feature from current repo context.

### `prompts/refactor-planning.md`
Use when planning a refactor without breaking conventions.

### `prompts/bug-investigation.md`
Use when diagnosing a defect using repo context.

### `prompts/task-expansion.md`
Use when turning goals or milestones into agent-ready tasks.

### `prompts/scaffold-generation.md`
Use when generating starter structure or code scaffolding.

---

## WHEN TO ADD MORE PROMPTS

Add new reusable prompts when:
- a workflow repeats
- you want more predictable agent behavior
- a project-specific workflow emerges
- handoffs to future sessions would benefit

---

## PROMPT DESIGN STANDARDS

Each prompt should include:
- role framing
- repo file references
- context discipline
- ambiguity handling rules
- expected output format
- update instructions when relevant
