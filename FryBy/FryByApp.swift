import SwiftUI
import SwiftData

@main
struct FryByApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: FryEntry.self)
    }
}
