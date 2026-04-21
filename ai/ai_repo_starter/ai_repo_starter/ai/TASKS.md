# TASKS.md

> This file is the repo's AI-friendly work tracker.
>  
> Keep it lightweight for small projects and structured for larger ones.

---

## PURPOSE OF THIS FILE

Use this file to:
- track implementation work
- generate agent-ready tasks
- manage milestones or epics when needed
- preserve what is next, in progress, blocked, or complete

Do not create fake complexity for tiny projects.

---

## TASK SYSTEM SIZE

### Current mode
- minimal
- standard
- structured

### Guidance
- **minimal** = short checklist for small projects
- **standard** = grouped tasks with acceptance criteria
- **structured** = milestone/epic + task IDs + dependencies

Selected:
[TBD]

---

## STATUS LEGEND

- `todo`
- `in_progress`
- `blocked`
- `done`
- `deferred`

---

## CURRENT FOCUS

- [TBD]

---

## MINIMAL MODE TEMPLATE

Use this when the project is small.

- [ ] Task
- [ ] Task
- [ ] Task

---

## STANDARD MODE TEMPLATE

### Task
- **ID:** T-[number]
- **Title:** [title]
- **Status:** todo | in_progress | blocked | done | deferred
- **Purpose:** [why this matters]
- **Scope:** [what is included]
- **Out of Scope:** [what is not included]
- **Prerequisites:** [dependencies]
- **Implementation Notes:** [helpful context]
- **Acceptance Criteria:**
  - [criterion]
  - [criterion]

---

## STRUCTURED MODE TEMPLATE

### Milestone / Epic
- **ID:** M-[number]
- **Title:** [title]
- **Outcome:** [what this milestone accomplishes]

#### Task
- **ID:** T-[number]
- **Title:** [title]
- **Status:** todo | in_progress | blocked | done | deferred
- **Parent:** M-[number]
- **Purpose:** [why]
- **Scope:** [included work]
- **Dependencies:** [task IDs or repo facts]
- **Agent Notes:** [instructions for an AI coding agent]
- **Acceptance Criteria:**
  - [criterion]
  - [criterion]

---

## AUTO TASK GENERATION RULES

When generating tasks:
- break work into slices that are implementation-ready
- avoid giant vague tasks
- include enough context that another agent could execute them
- derive tasks from confirmed project state, not wishful guesses
- keep dependencies explicit
- update status as the project moves

---

## ACTIVE TASKS

[TBD]

---

## BACKLOG

[TBD]

---

## BLOCKERS

[TBD]

---

## DONE

[TBD]
