import SwiftUI
import SwiftData

struct EntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FryEntry.date, order: .reverse) private var entries: [FryEntry]

    @State private var showingNewEntry = false
    @State private var searchText = ""

    private var filteredEntries: [FryEntry] {
        guard !searchText.isEmpty else { return entries }
        return entries.filter {
            $0.restaurantName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No Fry Entries Yet",
                    systemImage: "fork.knife",
                    description: Text("Tap + to log your first fry rating.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                }
                .onDelete(perform: deleteEntries)
            }
        }
        .navigationTitle("Fry Log")
        .searchable(text: $searchText, prompt: "Filter by restaurant")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingNewEntry = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            EntryFormView()
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredEntries[index])
        }
    }
}
