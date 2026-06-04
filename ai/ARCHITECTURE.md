# ARCHITECTURE.md

---

## STATUS

- Needed: yes
- Current depth: moderate

---

## SYSTEM OVERVIEW

### Architecture summary
Single iOS app. SwiftUI views backed by SwiftData for local persistence. No networking layer. Clean separation between models, scoring logic, and views.

### Architectural style
Single app — modular monolith by layer.

### Major components
- **Models** — SwiftData `@Model` classes and supporting enums
- **Scoring** — Protocol-based scoring strategy; fully isolated from views
- **Views** — SwiftUI view hierarchy organized by screen

### High-level data flow
```
User Input (EntryFormView)
    → FryFormData (form backing struct)
    → FryScorer.score(FryRatingInput) → Double
    → FryEntry (SwiftData @Model, persisted)
    → EntryListView / EntryDetailView (read from @Query)
```

---

## FOLDER STRUCTURE

```
FryBy.xcodeproj/
└── project.pbxproj       — committed Xcode project for simulator/device builds
FryBy/
├── FryByApp.swift
├── Models/
│   ├── FryEntry.swift          — SwiftData model, all fields + UUID
│   ├── FryType.swift           — Enum: Shoestring, Pub, Steak, Waffle, Curly, Crinkle
│   └── FryTemperature.swift    — Enum: Frozen → Piping Hot
├── Scoring/
│   ├── ScoringStrategy.swift   — Protocol, FryRatingInput, FryScorer entrypoint
│   └── DefaultFryScorer.swift  — Current algorithm (provisional weights)
└── Views/
    ├── FryTheme.swift          — shared Fry Lab HQ visual styling
    ├── Home/
    │   └── HomeView.swift
    ├── EntryList/
    │   ├── EntryListView.swift
    │   └── EntryRowView.swift
    ├── EntryDetail/
    │   └── EntryDetailView.swift
    └── EntryForm/
        ├── EntryFormView.swift  — includes FryFormData struct
        └── Components/
            ├── RatingSlider.swift    — 1–10 slider with colored label
            ├── SpectrumSlider.swift  — –4 to +4 spectrum slider
            └── RatioSlider.swift     — crispy:floppy ratio slider
```

---

## ARCHITECTURAL DRIVERS

- **Maintainability** — scoring algorithm expected to change; must be swappable without touching views
- **Extensibility** — social layer, other food categories, and Android will all require structural additions; current architecture should not actively resist them
- **Local-first** — no networking; SwiftData handles all persistence
- **AI-agent friendliness** — clean module boundaries so future agents can modify scoring, add a food type, or add screens without coupling side effects

---

## LAYER BOUNDARIES

### Models
- Plain value types and `@Model` class
- No knowledge of views or scoring
- `FryEntry` carries a stable `UUID` for future sync use

### Scoring
- `FryScoringStrategy` protocol defines the interface
- `FryRatingInput` is a pure value struct: decoupled from the model
- `FryScorer` is the static entrypoint; strategy can be swapped at runtime
- `DefaultFryScorer` is the current algorithm — all weights and normalization logic live here exclusively

### Views
- Views know about models and the scorer
- Views do not contain business logic
- `FryFormData` is a value-type form backing store in `EntryFormView.swift`; bridges form state to `FryRatingInput`

### Cross-boundary rules
- Views may read `FryEntry` properties directly
- Views call `FryScorer.score()` but never inspect scoring internals
- Scoring layer has no import of SwiftUI or SwiftData

---

## DATA MODEL

### FryEntry fields
| Field | Type | Notes |
|---|---|---|
| id | UUID | Stable identifier; unique constraint |
| restaurantName | String | Required |
| date | Date | Auto-filled; user-editable |
| notes | String? | Optional |
| fryType | FryType | Enum |
| temperature | FryTemperature | Enum |
| hungerLevel | Int | 1–10 |
| appearance | Int | 1–10 |
| undippedFlavor | Int | 1–10 |
| ketchupFlavor | Int? | Nullable |
| signatureSauceFlavor | Int? | Nullable |
| dunkability | Int? | Nullable |
| extraSeasoning | Int? | Nullable |
| starchiness | Int | –4 to +4; 0 = perfect |
| crispyFloppyRatio | Int | –4 (all crispy) to +4 (all floppy) |
| crispyQuality | Int? | –4 to +4; nullable |
| floppyQuality | Int? | –4 to +4; nullable |
| overallScore | Double | Computed at save time |

### Persistence
SwiftData with auto-save. No manual save calls needed in MVP.

---

## FUTURE ARCHITECTURE NOTES

### Social layer
When added, `FryEntry.id` (UUID) is the natural sync key. A new `SyncService` layer would sit alongside `Scoring/` and handle upload/merge without touching the existing view or model layer.

### Other food categories
The `Scoring` layer can be extended with a `FoodScoringStrategy` protocol that `FryScoringStrategy` inherits from, and food-type-specific models can mirror `FryEntry`'s structure. The `HomeView` would gain navigation links to new food log screens.

### Android
SwiftData is iOS-only. When Android support begins, a cross-platform data layer (e.g., Room on Android, or a shared server) would replace local persistence. The scoring logic is pure Swift — it can be ported or replicated.

---

## OPEN QUESTIONS

- Will scoring ever need to be async (e.g., ML model)?
- Should the home screen use a TabView when more food types are added, or stay NavigationStack-based?
