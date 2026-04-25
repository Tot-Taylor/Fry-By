# TASKS.md

> Work tracker for Fry-By.

---

## CURRENT MODE
standard

---

## STATUS LEGEND
- `done` — complete
- `todo` — not started
- `in_progress` — actively being worked
- `blocked` — waiting on something

---

## DONE

### T-001 — Project definition and AI file setup
- **Status:** done
- **Summary:** Completed full intake, shaping, and scaffolding phases. Confirmed stack, data model, scoring approach, screen structure. AI files written.

### T-002 — Initial scaffold: all Swift source files
- **Status:** done
- **Summary:** All Swift source files written: models, scoring layer, all views and components. Xcode project setup pending (manual step for user).

---

## ACTIVE TASKS

### T-003 — Xcode project setup
- **ID:** T-003
- **Title:** Create and configure Xcode project
- **Status:** todo
- **Purpose:** Wire all source files into a buildable Xcode project
- **Scope:** Create new iOS App project in Xcode, add all files from `FryBy/`, configure SwiftData container
- **Prerequisites:** T-002
- **Implementation Notes:** See `XCODE_SETUP.md` for step-by-step instructions
- **Acceptance Criteria:**
  - Project builds without errors
  - App launches on simulator
  - Home screen appears

### T-004 — Smoke test core flow
- **ID:** T-004
- **Title:** Verify end-to-end entry flow
- **Status:** todo
- **Purpose:** Confirm the MVP flow works: create entry → view in list → view detail → edit
- **Prerequisites:** T-003
- **Acceptance Criteria:**
  - Can create a new fry entry with all required fields
  - Entry appears in the fry log list with correct restaurant name, date, and score
  - Can tap entry to view detail — all fields displayed correctly
  - Can edit entry — changes persist
  - Entries survive app restart (SwiftData persistence confirmed)
  - Nullable fields correctly absent from detail view when not entered

### T-005 — Score algorithm review
- **ID:** T-005
- **Title:** Review and tune initial scoring weights
- **Status:** todo
- **Purpose:** Validate that the provisional scoring weights produce scores that feel right
- **Prerequisites:** T-004
- **Implementation Notes:** All weights are in `FryBy/Scoring/DefaultFryScorer.swift` under `Weights`. Modify only that file.
- **Acceptance Criteria:**
  - User has logged at least 5 entries
  - Overall scores feel proportional and meaningful
  - Weights adjusted if needed

---

## BACKLOG

- [ ] Add more filter/sort options to the entry list (by score, by fry type)
- [ ] Leaderboard view: best fries across all entries
- [ ] Stats screen: average score by restaurant, by fry type
- [ ] Re-score all entries button (apply updated algorithm to existing entries)
- [ ] Social layer: friends, activity feed (requires server)
- [ ] Android support
- [ ] Additional food categories
- [ ] Photos on entries
- [ ] Export / backup

---

## BLOCKERS

None currently.
