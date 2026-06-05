import SwiftUI

struct AnalyticsView: View {
    let entries: [FryEntry]
    let filteredEntries: [FryEntry]
    let isFiltering: Bool

    private var summary: FryAnalyticsSummary {
        FryAnalyticsSummary(entries: filteredEntries)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                analyticsHeader

                if entries.isEmpty {
                    analyticsEmptyState(
                        title: "No Fry Entries Yet",
                        systemImage: "chart.bar.doc.horizontal",
                        message: "Log your first fry rating to unlock trends, rankings, and map-ready insights."
                    )
                } else if filteredEntries.isEmpty {
                    analyticsEmptyState(
                        title: "No Entries Match Filters",
                        systemImage: "line.3.horizontal.decrease.circle",
                        message: "Adjust your diary search to include more restaurants in these analytics."
                    )
                } else {
                    summaryMetricsGrid
                    scoreTrendCard
                    topRestaurantsCard
                    fryTypeBreakdownCard
                    mapPreparationCard
                }
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .scrollContentBackground(.hidden)
    }

    private var analyticsHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Analytics", systemImage: "chart.bar.xaxis")
                .font(.title.bold())
                .foregroundStyle(FryTheme.text)

            Text("A summary framework for fry trends, chart cards, and future location-based insights.")
                .font(.subheadline)
                .foregroundStyle(FryTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var summaryMetricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            AnalyticsMetricTile(
                title: "Entries",
                value: "\(summary.entryCount)",
                caption: isFiltering ? "Matching filters" : "Logged ratings",
                systemImage: "fork.knife"
            )

            AnalyticsMetricTile(
                title: "Average Score",
                value: summary.averageScoreText,
                caption: "Across selected entries",
                systemImage: "star.fill",
                valueColor: summary.averageScore.map(FryTheme.scoreColor) ?? FryTheme.mutedText
            )

            AnalyticsMetricTile(
                title: "Best Score",
                value: summary.bestScoreText,
                caption: summary.bestRestaurantName ?? "Needs score data",
                systemImage: "trophy.fill",
                valueColor: summary.bestEntry.map { FryTheme.scoreColor($0.overallScore) } ?? FryTheme.mutedText
            )

            AnalyticsMetricTile(
                title: "Favorite Type",
                value: summary.favoriteFryTypeText,
                caption: summary.favoriteFryTypeCaption,
                systemImage: "chart.pie.fill"
            )
        }
    }

    private var scoreTrendCard: some View {
        AnalyticsChartCard(
            title: "Score Trend",
            subtitle: "Ready for a future line chart of scores over time.",
            systemImage: "chart.xyaxis.line"
        ) {
            if summary.scoreTrendPoints.count < 2 {
                AnalyticsMissingDataView(
                    title: "Missing Trend Data",
                    message: "Add at least two fry entries to compare scores over time."
                )
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(summary.scoreTrendPoints.prefix(5)) { point in
                        AnalyticsProgressRow(
                            label: point.label,
                            valueText: String(format: "%.1f", point.score),
                            fraction: point.score / 10,
                            tint: FryTheme.scoreColor(point.score)
                        )
                    }

                    if summary.scoreTrendPoints.count > 5 {
                        Text("+ \(summary.scoreTrendPoints.count - 5) more points ready for charting")
                            .font(.caption)
                            .foregroundStyle(FryTheme.mutedText)
                    }
                }
            }
        }
    }

    private var topRestaurantsCard: some View {
        AnalyticsChartCard(
            title: "Top Restaurants",
            subtitle: "Prepared for ranked bar chart visualization.",
            systemImage: "list.number"
        ) {
            if summary.topRestaurants.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Restaurant Data",
                    message: "Restaurant rankings will appear once entries include scores."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(summary.topRestaurants) { restaurant in
                        AnalyticsProgressRow(
                            label: restaurant.name,
                            valueText: String(format: "%.1f", restaurant.averageScore),
                            fraction: restaurant.averageScore / 10,
                            tint: FryTheme.scoreColor(restaurant.averageScore)
                        )
                    }
                }
            }
        }
    }

    private var fryTypeBreakdownCard: some View {
        AnalyticsChartCard(
            title: "Fry Type Breakdown",
            subtitle: "Counts are grouped for a future donut or bar chart.",
            systemImage: "chart.pie"
        ) {
            if summary.fryTypeBreakdown.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Fry Type Data",
                    message: "Choose fry types on entries to build this breakdown."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(summary.fryTypeBreakdown) { item in
                        AnalyticsProgressRow(
                            label: item.type.rawValue,
                            valueText: "\(item.count)",
                            fraction: Double(item.count) / Double(max(summary.entryCount, 1)),
                            tint: FryTheme.fryLight
                        )
                    }
                }
            }
        }
    }

    private var mapPreparationCard: some View {
        AnalyticsChartCard(
            title: "Map Insights",
            subtitle: "Reserved for a future interactive map ticket.",
            systemImage: "map"
        ) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(FryTheme.cardElevated.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 6]))
                                .foregroundStyle(FryTheme.cardStroke.opacity(0.9))
                        )
                        .frame(height: 150)

                    VStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(FryTheme.fry)
                        Text("Interactive map placeholder")
                            .font(.headline)
                            .foregroundStyle(FryTheme.text)
                        Text("Location fields and map rendering are intentionally not implemented yet.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(FryTheme.mutedText)
                            .padding(.horizontal)
                    }
                }

                AnalyticsMissingDataView(
                    title: "Missing Location Data",
                    message: "Future map cards can consume geocoded restaurant locations when that data exists."
                )
            }
        }
    }

    private func analyticsEmptyState(title: String, systemImage: String, message: String) -> some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text(message)
        )
        .foregroundStyle(FryTheme.text)
        .frame(maxWidth: .infinity, minHeight: 360)
        .fryCardStyle()
    }
}

private struct FryAnalyticsSummary {
    let entries: [FryEntry]

    var entryCount: Int { entries.count }

    var averageScore: Double? {
        guard !entries.isEmpty else { return nil }
        return entries.map(\.overallScore).reduce(0, +) / Double(entries.count)
    }

    var averageScoreText: String {
        averageScore.map { String(format: "%.1f", $0) } ?? "—"
    }

    var bestEntry: FryEntry? {
        entries.max { $0.overallScore < $1.overallScore }
    }

    var bestScoreText: String {
        bestEntry.map { String(format: "%.1f", $0.overallScore) } ?? "—"
    }

    var bestRestaurantName: String? {
        bestEntry?.restaurantName
    }

    var favoriteFryTypeText: String {
        favoriteFryType?.type.rawValue ?? "—"
    }

    var favoriteFryTypeCaption: String {
        guard let favoriteFryType else { return "Needs fry type data" }
        return "\(favoriteFryType.count) logged"
    }

    var favoriteFryType: FryTypeBreakdownItem? {
        fryTypeBreakdown.first
    }

    var scoreTrendPoints: [ScoreTrendPoint] {
        entries
            .sorted { $0.date < $1.date }
            .map { entry in
                ScoreTrendPoint(
                    id: entry.id,
                    label: Self.shortDateFormatter.string(from: entry.date),
                    score: entry.overallScore
                )
            }
    }

    var topRestaurants: [RestaurantScoreSummary] {
        let groupedEntries = Dictionary(grouping: entries) { $0.restaurantName }

        return groupedEntries.map { name, restaurantEntries in
            let totalScore = restaurantEntries.map(\.overallScore).reduce(0, +)
            return RestaurantScoreSummary(
                name: name,
                averageScore: totalScore / Double(restaurantEntries.count),
                entryCount: restaurantEntries.count
            )
        }
        .sorted {
            if $0.averageScore == $1.averageScore {
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            return $0.averageScore > $1.averageScore
        }
        .prefix(5)
        .map { $0 }
    }

    var fryTypeBreakdown: [FryTypeBreakdownItem] {
        FryType.allCases.compactMap { type in
            let count = entries.filter { $0.fryType == type }.count
            guard count > 0 else { return nil }
            return FryTypeBreakdownItem(type: type, count: count)
        }
        .sorted {
            if $0.count == $1.count {
                return $0.type.rawValue < $1.type.rawValue
            }
            return $0.count > $1.count
        }
    }

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

private struct ScoreTrendPoint: Identifiable {
    let id: UUID
    let label: String
    let score: Double
}

private struct RestaurantScoreSummary: Identifiable {
    var id: String { name }
    let name: String
    let averageScore: Double
    let entryCount: Int
}

private struct FryTypeBreakdownItem: Identifiable {
    var id: FryType { type }
    let type: FryType
    let count: Int
}

private struct AnalyticsMetricTile: View {
    let title: String
    let value: String
    let caption: String
    let systemImage: String
    var valueColor: Color = FryTheme.fryLight

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(FryTheme.fry)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2.weight(.black))
                    .foregroundStyle(valueColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(title)
                    .font(.caption.weight(.bold))
                    .textCase(.uppercase)
                    .tracking(0.8)
                    .foregroundStyle(FryTheme.text)

                Text(caption)
                    .font(.caption)
                    .foregroundStyle(FryTheme.mutedText)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .fryCardStyle()
    }
}

private struct AnalyticsChartCard<Content: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let content: Content

    init(title: String, subtitle: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        FrySectionCard(title: title) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(FryTheme.fry)
                    .frame(width: 28)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(FryTheme.mutedText)
            }

            FryDivider()

            content
        }
    }
}

private struct AnalyticsProgressRow: View {
    let label: String
    let valueText: String
    let fraction: Double
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(FryTheme.text)
                    .lineLimit(1)
                Spacer()
                Text(valueText)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(tint)
                    .monospacedDigit()
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(FryTheme.cardStroke.opacity(0.65))
                    Capsule()
                        .fill(tint)
                        .frame(width: proxy.size.width * min(max(fraction, 0), 1))
                }
            }
            .frame(height: 8)
        }
    }
}

private struct AnalyticsMissingDataView: View {
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(FryTheme.fry)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(FryTheme.text)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(FryTheme.mutedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(FryTheme.cardElevated.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
