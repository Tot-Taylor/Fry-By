# Xcode Project Setup

All Swift source files are in `FryBy/`. Follow these steps to create the Xcode project and link them.

---

## Steps

### 1. Create a new Xcode project

- Open Xcode
- File > New > Project
- Choose **iOS > App**
- Configure:
  - **Product Name:** FryBy
  - **Team:** your team or None
  - **Bundle Identifier:** com.yourname.fryby (or whatever you prefer)
  - **Interface:** SwiftUI
  - **Language:** Swift
  - **Storage:** None (we manage SwiftData manually)
- Save the project **inside this repo folder** so the `.xcodeproj` sits next to the `FryBy/` source directory

### 2. Delete the Xcode-generated boilerplate

In the Xcode project navigator, delete:
- `ContentView.swift`
- `FryByApp.swift` (Xcode generates its own — delete it, we have ours)
- Any auto-generated `Item.swift` or sample model file

Choose **Move to Trash** when prompted.

### 3. Add the source files to the project

- In Xcode's project navigator, right-click the `FryBy` group
- Choose **Add Files to "FryBy"...**
- Navigate to the `FryBy/` folder in this repo
- Select all folders: `Models/`, `Scoring/`, `Views/`, and `FryByApp.swift`
- Make sure **"Copy items if needed"** is **unchecked** (files are already in the right place)
- Make sure **"Add to target: FryBy"** is checked
- Click **Add**

### 4. Set the deployment target

- Click the project in the navigator
- Under **Targets > FryBy > General > Minimum Deployments**
- Set to **iOS 17.0**

### 5. Build and run

- Select an iOS 17+ simulator
- Press **Cmd+R**
- The app should build clean and launch to the home screen

---

## Troubleshooting

**"Cannot find type FryEntry"** — make sure all files in `Models/` were added to the target.

**"No such module SwiftData"** — confirm deployment target is iOS 17+.

**Duplicate `@main`** — make sure you deleted Xcode's generated `FryByApp.swift` and only the one in `FryBy/FryByApp.swift` remains.
