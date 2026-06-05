import SwiftUI

struct EntryDetailView: View {
    let entry: FryEntry
    @State private var showingEditForm = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                overviewSection
                flavorSection
                textureSection
                contextSection
                if let notes = entry.notes, !notes.isEmpty {
                    FrySectionCard(title: "Notes") {
                        Text(notes)
                            .foregroundStyle(FryTheme.text)
                    }
                }
            }
            .padding(16)
        }
        .fryBackground()
        .navigationTitle(entry.restaurantName)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(FryTheme.backgroundGlow, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            Button("Edit") { showingEditForm = true }
        }
        .sheet(isPresented: $showingEditForm) {
            EntryFormView(entry: entry)
        }
    }

    // MARK: - Sections

    private var overviewSection: some View {
        FrySectionCard(title: "Overview") {
            detailRow("Restaurant", value: entry.restaurantName)
            FryDivider()
            detailRow("Date", value: entry.date.formatted(date: .long, time: .shortened))
            FryDivider()
            HStack {
                Text("Overall Score")
                    .foregroundStyle(FryTheme.text)
                Spacer()
                ZStack {
                    Circle()
                        .stroke(FryTheme.cardStroke.opacity(0.8), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: min(max(entry.overallScore / 10, 0), 1))
                        .stroke(
                            FryTheme.scoreColor(entry.overallScore),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    Text(String(format: "%.1f / 10", entry.overallScore))
                        .font(.subheadline)
                        .fontWeight(.black)
                        .foregroundStyle(FryTheme.scoreColor(entry.overallScore))
                        .monospacedDigit()
                }
                .frame(width: 96, height: 96)
            }
            FryDivider()
            detailRow("Fry Type", value: entry.fryType.rawValue)
            FryDivider()
            detailRow("Temperature", value: entry.temperature.rawValue)
        }
    }

    private var flavorSection: some View {
        FrySectionCard(title: "Flavor") {
            ratingRow("Undipped Flavor", value: entry.undippedFlavor)
            if let v = entry.ketchupFlavor {
                FryDivider()
                ratingRow("Flavor in Ketchup", value: v)
            }
            if let v = entry.signatureSauceFlavor {
                FryDivider()
                if let name = entry.signatureSauceName, !name.isEmpty {
                    detailRow("Other Sauce", value: name)
                    FryDivider()
                    ratingRow("Flavor in \(name)", value: v)
                } else {
                    ratingRow("Other Sauce Flavor", value: v)
                }
            }
            if let v = entry.dunkability {
                FryDivider()
                ratingRow("Sauce Retention", value: v)
            }
            if let v = entry.extraSeasoning {
                FryDivider()
                if let name = entry.extraSeasoningName, !name.isEmpty {
                    detailRow("Extra Seasoning", value: name)
                    FryDivider()
                    ratingRow("Flavor with \(name)", value: v)
                } else {
                    ratingRow("Flavor with Extra Seasoning", value: v)
                }
            }
        }
    }

    private var textureSection: some View {
        FrySectionCard(title: "Texture") {
            spectrumRow(
                "Starchiness",
                value: entry.starchiness,
                negativeLabel: "Not Starchy Enough",
                positiveLabel: "Too Starchy"
            )
            FryDivider()
            detailRow("Crispy to Floppy Ratio", value: ratioLabel(entry.crispyFloppyRatio))
            if let v = entry.crispyQuality {
                FryDivider()
                spectrumRow(
                    "Crispy Quality",
                    value: v,
                    negativeLabel: "Not Crispy Enough",
                    positiveLabel: "Too Crispy"
                )
            }
            if let v = entry.floppyQuality {
                FryDivider()
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
        FrySectionCard(title: "Context") {
            ratingRow("Appearance", value: entry.appearance)
            FryDivider()
            ratingRow("Hunger Level", value: entry.hungerLevel)
        }
    }

    // MARK: - Row helpers

    @ViewBuilder
    private func detailRow(_ label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(FryTheme.text)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(FryTheme.mutedText)
                .multilineTextAlignment(.trailing)
        }
    }

    @ViewBuilder
    private func ratingRow(_ label: String, value: Int) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(FryTheme.text)
            Spacer()
            HStack(spacing: 2) {
                Text("\(value)")
                    .fontWeight(.black)
                    .foregroundStyle(FryTheme.ratingColor(value))
                Text("/ 10")
                    .font(.caption)
                    .foregroundStyle(FryTheme.mutedText)
            }
        }
    }

    @ViewBuilder
    private func spectrumRow(_ label: String, value: Int, negativeLabel: String, positiveLabel: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(FryTheme.text)
            Spacer()
            Text(spectrumDisplayText(value: value, negativeLabel: negativeLabel, positiveLabel: positiveLabel))
                .fontWeight(.semibold)
                .foregroundStyle(value == 0 ? FryTheme.success : FryTheme.mutedText)
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: - Display helpers

    private func ratioLabel(_ value: Int) -> String {
        switch value {
        case -4: return "All Crispy"
        case -3: return "Mostly Crispy (4:1)"
        case -2: return "More Crispy (2:1)"
        case -1: return "Slightly Crispy (4:3)"
        case  0: return "Even Split"
        case  1: return "Slightly Floppy (4:3)"
        case  2: return "More Floppy (2:1)"
        case  3: return "Mostly Floppy (4:1)"
        case  4: return "All Floppy"
        default: return "Even Split"
        }
    }

    private func spectrumDisplayText(value: Int, negativeLabel: String, positiveLabel: String) -> String {
        if value == 0 { return "Perfect" }
        let label = value < 0 ? negativeLabel : positiveLabel
        let sign = value > 0 ? "+" : ""
        return "\(label) (\(sign)\(value))"
    }
}
