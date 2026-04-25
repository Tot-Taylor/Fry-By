import SwiftUI

struct EntryDetailView: View {
    let entry: FryEntry
    @State private var showingEditForm = false

    var body: some View {
        List {
            overviewSection
            flavorSection
            textureSection
            contextSection
            if let notes = entry.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(entry.restaurantName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Button("Edit") { showingEditForm = true }
        }
        .sheet(isPresented: $showingEditForm) {
            EntryFormView(entry: entry)
        }
    }

    // MARK: - Sections

    private var overviewSection: some View {
        Section("Overview") {
            LabeledContent("Restaurant", value: entry.restaurantName)
            LabeledContent("Date", value: entry.date.formatted(date: .long, time: .shortened))
            HStack {
                Text("Overall Score")
                Spacer()
                Text(String(format: "%.1f / 10", entry.overallScore))
                    .fontWeight(.bold)
                    .foregroundStyle(scoreColor(entry.overallScore))
            }
            LabeledContent("Fry Type", value: entry.fryType.rawValue)
            LabeledContent("Temperature", value: entry.temperature.rawValue)
        }
    }

    private var flavorSection: some View {
        Section("Flavor") {
            ratingRow("Undipped Flavor", value: entry.undippedFlavor)
            if let v = entry.ketchupFlavor        { ratingRow("Dipped in Ketchup", value: v) }
            if let v = entry.signatureSauceFlavor  { ratingRow("Signature Sauce Dipped", value: v) }
            if let v = entry.dunkability           { ratingRow("Dunkability", value: v) }
            if let v = entry.extraSeasoning        { ratingRow("Extra Seasoning", value: v) }
        }
    }

    private var textureSection: some View {
        Section("Texture") {
            spectrumRow(
                "Starchiness",
                value: entry.starchiness,
                negativeLabel: "Not Starchy Enough",
                positiveLabel: "Too Starchy"
            )
            LabeledContent("Crispy:Floppy Ratio", value: ratioLabel(entry.crispyFloppyRatio))
            if let v = entry.crispyQuality {
                spectrumRow(
                    "Crispy Quality",
                    value: v,
                    negativeLabel: "Not Crispy Enough",
                    positiveLabel: "Over-Crispy"
                )
            }
            if let v = entry.floppyQuality {
                spectrumRow(
                    "Floppy Quality",
                    value: v,
                    negativeLabel: "Not Floppy Enough",
                    positiveLabel: "Too Floppy"
                )
            }
        }
    }

    private var contextSection: some View {
        Section("Context") {
            ratingRow("Appearance", value: entry.appearance)
            ratingRow("Hunger Level", value: entry.hungerLevel)
        }
    }

    // MARK: - Row helpers

    @ViewBuilder
    private func ratingRow(_ label: String, value: Int) -> some View {
        HStack {
            Text(label)
            Spacer()
            HStack(spacing: 2) {
                Text("\(value)")
                    .fontWeight(.semibold)
                    .foregroundStyle(ratingColor(value))
                Text("/ 10")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func spectrumRow(_ label: String, value: Int, negativeLabel: String, positiveLabel: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(spectrumDisplayText(value: value, negativeLabel: negativeLabel, positiveLabel: positiveLabel))
                .foregroundStyle(value == 0 ? Color.green : Color.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: - Display helpers

    private func ratioLabel(_ value: Int) -> String {
        switch value {
        case -4: return "All Crispy (5:0)"
        case -3: return "Mostly Crispy (4:1)"
        case -2: return "More Crispy (3:2)"
        case -1: return "Slightly More Crispy"
        case  0: return "Even Split (1:1)"
        case  1: return "Slightly More Floppy"
        case  2: return "More Floppy (2:3)"
        case  3: return "Mostly Floppy (1:4)"
        case  4: return "All Floppy (0:5)"
        default: return "Even Split (1:1)"
        }
    }

    private func spectrumDisplayText(value: Int, negativeLabel: String, positiveLabel: String) -> String {
        if value == 0 { return "Perfect" }
        let label = value < 0 ? negativeLabel : positiveLabel
        let sign = value > 0 ? "+" : ""
        return "\(label) (\(sign)\(value))"
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 8...: return .green
        case 6..<8: return .yellow
        case 4..<6: return .orange
        default: return .red
        }
    }

    private func ratingColor(_ value: Int) -> Color {
        switch value {
        case 8...10: return .green
        case 5..<8:  return .yellow
        case 3..<5:  return .orange
        default:     return .red
        }
    }
}
