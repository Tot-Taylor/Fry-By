# PROJECT_SPEC.md

> Canonical evolving project specification.

---

## PROJECT SNAPSHOT

### Name
Fry-By

### One-Sentence Summary
A personal iOS app for rating French fries across detailed criteria, with all data stored locally on-device.

### Current Phase
- [x] intake
- [x] shaping
- [x] scaffolding
- [ ] implementation ← current
- [ ] maintenance

### Project Scale
- [ ] small
- [x] medium
- [ ] large

### Confidence Level
- [ ] low
- [ ] medium
- [x] high

---

## RAW IDEA

### User-provided idea
An app used to rate French fries on a variety of criteria. Scoped to French fries for now, with other foods planned for future expansion.

### Problem being solved
No good tool exists for tracking and comparing fry quality across restaurants using meaningful, granular criteria.

### Why this project matters
Personal + friend-group use. Creates a structured, persistent record of fry experiences to compare restaurants and fry types over time.

---

## USERS AND USE CASES

### Target users
- Primary user and their friend group

### Primary use cases
- Log a new fry rating after visiting a restaurant
- View past fry entries
- Compare ratings across restaurants

### Secondary use cases
- Retroactively add entries for past experiences (date/time is editable)
- Filter entry list by restaurant name

### Out-of-scope use cases (current)
- Social features (friends, activity feed) — deferred
- Android support — deferred
- Other food categories — deferred
- Photos on entries — deferred
- Server-side storage or syncing — deferred

---

## GOALS

### Primary goals
- Log fry ratings with detailed criteria
- Persist ratings across app sessions (local SwiftData)
- View a filterable list of past entries
- View full detail of any past entry
- Edit existing entries

### Secondary goals
- Clean, intuitive UX for a fun personal tool
- Architecture that doesn't fight future social/sync layer

### Non-goals (MVP)
- Accounts, auth, server
- Sharing or export
- Push notifications
- Widgets

### First version success criteria
- Can log a new fry entry with all required criteria
- Can mark optional fields as N/A
- Entries persist after closing the app
- Can view a list of past entries sorted by date
- Can tap an entry to see full detail
- Can edit an existing entry

---

## SCOPE SHAPE

### MVP / first usable version
Home screen → Fry Log list → New Entry form → Detail view + Edit

### Likely later expansions
- Social layer: friends, activity feeds, shared ratings
- Other food categories (burger, pizza, etc.)
- Android support
- Photos on entries
- Advanced leaderboard / stats views
- Revised scoring algorithm based on real usage data

### What is intentionally deferred
Everything in the future scope list above.

---

## CONSTRAINTS

### Technical constraints
- iOS 17+ required (SwiftData dependency)
- Swift + Xcode only
- No network layer in MVP

### Maintenance expectations
- Actively maintained and likely to expand substantially

---

## CONFIRMED DECISIONS

- **Platform:** iOS only (Android deferred)
- **Language/Framework:** Swift + SwiftUI
- **Persistence:** SwiftData (local, on-device only)
- **Minimum OS:** iOS 17
- **Data stays local:** No server, no sync in MVP
- **Home screen is bare but extensible:** No placeholder buttons; structured to add nav destinations later
- **Scoring is fully modular:** All logic in a single swappable module; zero leakage into views
- **Overall score stored at save time:** Score is computed and persisted; doesn't retroactively change if algorithm updates
- **Nullable fields:** ketchupFlavor, signatureSauceFlavor, dunkability, extraSeasoning, crispyQuality, floppyQuality
- **Spectrum sliders use -4 to +4:** 9 discrete steps; 0 = ideal
- **Crispy:Floppy ratio uses same -4/+4 scale:** Left = more crispy, right = more floppy; displayed as ratio labels (e.g. "4:1", "1:1", "0:5")
- **UUID on every entry:** Stable identifier for future sync/social layer

---

## OPEN QUESTIONS

- What weights should each scoring criterion carry? (Current weights are provisional placeholders)
- Will the overall score ever need to be retroactively recomputed for all entries?

---

## CURRENT PRIORITIES

1. Get Xcode project created and wired to source files
2. Verify SwiftData model persists correctly
3. Verify entry form saves and displays correctly
4. Test edit flow end-to-end

---

## REPO AI FILE MAP

### Currently active
- `AI_ENTRY.md`
- `PROJECT_SPEC.md`
- `ARCHITECTURE.md`
- `TASKS.md`
- `DECISIONS.md`

### Create when needed
- `PROMPTS.md`
- `SCAFFOLDING.md`
- `TEST_STRATEGY.md`
- `API_SPEC.md` (when social/server layer begins)
- `DOMAIN_MODEL.md` (when food categories expand)
