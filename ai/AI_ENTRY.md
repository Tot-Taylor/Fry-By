# AI_ENTRY.md

> Single invocation file for AI-assisted work on Fry-By.
> Read this file first, then read the other AI files as needed for context.

---

## PROJECT IDENTITY

**Name:** Fry-By
**Type:** iOS mobile app (Swift + SwiftUI + SwiftData)
**Purpose:** Personal French fry rating app for a friend group
**Phase:** Implementation
**Maturity:** Source files written; Xcode project setup pending

---

## HOW TO USE THIS FILE

When invoked, you must:
1. Read this file
2. Determine what the user wants to do
3. Read only the AI files relevant to the task (don't load all files blindly)
4. Ask targeted questions if intent is unclear
5. Update AI files when meaningful decisions or changes occur

---

## CURRENT STATE (as of 2026-04-24)

- All Swift source files written in `FryBy/` directory
- AI files fully populated
- Xcode project has NOT been created yet — T-003 is the next manual step
- Scoring algorithm is provisional; weights in `DefaultFryScorer.swift` will change

---

## KEY FILES

| File | Purpose |
|---|---|
| `FryBy/Models/FryEntry.swift` | Main data model |
| `FryBy/Scoring/DefaultFryScorer.swift` | Scoring algorithm — modify here to tune weights |
| `FryBy/Scoring/ScoringStrategy.swift` | Scoring protocol + FryRatingInput + FryScorer entrypoint |
| `FryBy/Views/EntryForm/EntryFormView.swift` | Entry creation/edit form + FryFormData struct |
| `XCODE_SETUP.md` | Step-by-step Xcode project setup instructions |

---

## CONFIRMED DECISIONS (summary)

- iOS 17+, Swift, SwiftUI, SwiftData
- All data local (no server in MVP)
- Scoring is fully modular — never bake algorithm logic outside `Scoring/`
- UUID on every entry for future sync compatibility
- Spectrum sliders: –4 to +4, 9 discrete steps, 0 = ideal
- Nullable fields: ketchupFlavor, signatureSauceFlavor, dunkability, extraSeasoning, crispyQuality, floppyQuality
- Home screen: bare but extensible (no placeholder UI)
- Overall score stored at save time, not recomputed live

See `DECISIONS.md` for full decision log.

---

## ACTIVE AI FILES

- `AI_ENTRY.md` ← this file
- `PROJECT_SPEC.md` — full product spec
- `ARCHITECTURE.md` — folder structure, layer boundaries, data model
- `DECISIONS.md` — decision log with rationale
- `TASKS.md` — task tracker

---

## HARD RULES

1. Never put scoring logic outside `FryBy/Scoring/`.
2. Never hardcode weights or score formulas in views or models.
3. Keep `HomeView` clean — no placeholder buttons for unbuilt features.
4. All nullable fields must remain nullable; do not add forced defaults.
5. Update `TASKS.md` and `DECISIONS.md` when meaningful changes are made.
