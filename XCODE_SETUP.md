# Xcode Project Setup

This repo now includes a committed Xcode project at `FryBy.xcodeproj`.

## Open and run

1. Open `FryBy.xcodeproj` in Xcode.
2. Select the `FryBy` scheme.
3. Select an iOS 17+ simulator.
4. Press **Cmd+R**.

The app sources live in the `FryBy/` folder and are already linked in the project file.

## Project configuration

- **Product Name:** FryBy
- **Interface:** SwiftUI
- **Language:** Swift
- **Storage:** SwiftData is configured in `FryBy/FryByApp.swift`
- **Minimum deployment target:** iOS 17.0
- **Generated Info.plist:** enabled through Xcode build settings

## Troubleshooting

**`FryBy.xcodeproj cannot be opened because it is missing its project.pbxproj file`** — this means the `.xcodeproj` bundle on disk is incomplete. Pull the latest repo version and confirm `FryBy.xcodeproj/project.pbxproj` exists.

**`Cannot find type FryEntry`** — make sure `FryBy.xcodeproj/project.pbxproj` includes the files under `FryBy/Models/` in the `FryBy` target sources.

**`No such module SwiftData`** — confirm you are using Xcode 15+ and an iOS 17+ deployment target/simulator.

**Code signing errors on device** — set your Apple Development Team under **Targets > FryBy > Signing & Capabilities**. Simulator builds should not require a paid team.
