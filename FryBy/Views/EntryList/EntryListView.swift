import SwiftUI
import SwiftData

struct EntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FryEntry.date, order: .reverse) private var entries: [FryEntry]

    @State private var selectedTab: FryLogTab = .diary
    @State private var showingNewEntry = false
    @State private var searchText = ""

    private var filteredEntries: [FryEntry] {
        guard !searchText.isEmpty else { return entries }
        return entries.filter {
            $0.restaurantName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            switch selectedTab {
            case .diary:
                diaryList
            case .analytics:
                AnalyticsPlaceholderView()
            }
        }
        .background(FryTheme.backgroundGradient.ignoresSafeArea())
        .navigationTitle("Fry Log")
        .toolbarBackground(FryTheme.backgroundGlow, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(FryTheme.fry)
        .diarySearchable(when: selectedTab == .diary, text: $searchText)
        .safeAreaInset(edge: .top, spacing: 0) {
            tabSwitcher
        }
        .toolbar {
            if selectedTab == .diary {
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
        }
        .sheet(isPresented: $showingNewEntry) {
            EntryFormView()
        }
    }

    private var diaryList: some View {
        List {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No Fry Entries Yet",
                    systemImage: "fork.knife",
                    description: Text("Tap + to log your first fry rating.")
                )
                .foregroundStyle(FryTheme.text)
                .listRowBackground(Color.clear)
            } else {
                ForEach(filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .onDelete(perform: deleteEntries)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var tabSwitcher: some View {
        Picker("Fry log section", selection: $selectedTab) {
            ForEach(FryLogTab.allCases) { tab in
                Label(tab.title, systemImage: tab.systemImage)
                    .tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background {
            Rectangle()
                .fill(FryTheme.backgroundGlow)
                .overlay {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .ignoresSafeArea(edges: .top)
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredEntries[index])
        }
    }
}

private enum FryLogTab: String, CaseIterable, Identifiable {
    case diary
    case analytics

    var id: String { rawValue }

    var title: String {
        switch self {
        case .diary:
            "Diary"
        case .analytics:
            "Analytics"
        }
    }

    var systemImage: String {
        switch self {
        case .diary:
            "book.pages"
        case .analytics:
            "chart.bar.xaxis"
        }
    }
}

private struct AnalyticsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 52, weight: .semibold))
                .foregroundStyle(FryTheme.fry)
                .shadow(color: FryTheme.fry.opacity(0.35), radius: 18, x: 0, y: 8)

            VStack(spacing: 8) {
                Text("Analytics")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(FryTheme.text)
                Text("Your fry insights will live here soon.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(FryTheme.mutedText)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }
}

private extension View {
    @ViewBuilder
    func diarySearchable(when isEnabled: Bool, text: Binding<String>) -> some View {
        if isEnabled {
            searchable(text: text, prompt: "Filter by restaurant")
        } else {
            self
        }
    }
}
