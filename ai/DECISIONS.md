# DECISIONS.md

> Durable record of important project decisions and why they were made.

---

## D-001 — SwiftData for local persistence

**Decision:** Use SwiftData (iOS 17+) instead of CoreData or SQLite.

**Why:** SwiftData is the modern Swift-native ORM. It integrates directly with SwiftUI via `@Query` and `@Model`. CoreData is legacy. SQLite requires manual schema management. The tradeoff is iOS 17+ requirement, which is acceptable given the personal-use target audience.

**Impact:** Minimum deployment target is iOS 17.

---

## D-002 — Scoring logic is fully modular

**Decision:** All scoring logic lives in `Scoring/`. No weights, formulas, or field mappings exist anywhere else in the codebase.

**Why:** The user explicitly stated the algorithm is provisional and will change. The entire scoring approach may be redesigned. Keeping it isolated means any change is a single-file edit. Views and the model are insulated from algorithm churn.

**How:** `FryScoringStrategy` protocol defines the interface. `FryRatingInput` is a pure value struct used as input. `FryScorer` is a static entrypoint. `DefaultFryScorer` is the concrete algorithm. Swapping the algorithm = implementing `FryScoringStrategy` and assigning to `FryScorer.strategy`.

---

## D-003 — Overall score stored at save time, not computed live

**Decision:** `overallScore` is computed once (at create or edit) and stored in the SwiftData model.

**Why:** If the algorithm changes, past entries retain the score they earned under the algorithm that was active when they were logged. This preserves historical integrity. Future feature: "re-score all entries" button if the user wants to apply a new algorithm retroactively.

---

## D-004 — UUID on every FryEntry

**Decision:** Every `FryEntry` carries a stable `UUID` with a unique constraint.

**Why:** Future social/sync feature will require a stable identifier for merging and deduplication across devices. Adding UUID later would require a migration. Adding it now is free.

---

## D-005 — Spectrum sliders use integer –4 to +4

**Decision:** Starchiness, crispy quality, floppy quality, and crispy:floppy ratio all use Int in range –4 to +4 with 9 discrete steps. Zero is always the ideal or neutral center.

**Why:** Matches the user's mental model ("a spectrum with 4-5 values on each side of center"). Integer storage is simple and unambiguous. Display labels translate the number to human-readable text.

---

## D-006 — Home screen is navigation-root, no placeholder UI

**Decision:** `HomeView` is a real navigation root with only currently functional UI. No placeholder buttons for future features.

**Why:** User specified explicitly. The view is structured as a `NavigationStack` root so future navigation destinations (other food types, friends, stats) can be added as new `NavigationLink` items without restructuring the screen.

---

## D-007 — Nullable fields use Toggle + conditional reveal in form

**Decision:** Nullable rating fields (ketchup, signature sauce, dunkability, extra seasoning, crispy quality, floppy quality) are controlled by a `Toggle` in the entry form. When off, the field is `nil`. When on, the rating slider appears.

**Why:** Users frequently won't have access to all fields (no signature sauce at some restaurants, no floppy fries in a batch, etc.). Forcing entry of all fields would make the form unusable. Toggle pattern is the clearest way to communicate "this field was not applicable."

---

## D-008 — FryFormData as form backing struct

**Decision:** A value-type `FryFormData` struct backs `EntryFormView`'s state. It converts to `FryRatingInput` for scoring and to `FryEntry` for persistence.

**Why:** Avoids @State sprawl across 20+ fields. Cleanly initializes from an existing `FryEntry` for edit mode. Provides a single `ratingInput` computed property that bridges the form to the scoring layer.
