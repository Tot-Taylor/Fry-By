import Charts
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
                        message: "Log your first fry rating to unlock score, volume, and restaurant analytics."
                    )
                } else if filteredEntries.isEmpty {
                    analyticsEmptyState(
                        title: "No Entries Match Filters",
                        systemImage: "line.3.horizontal.decrease.circle",
                        message: "Adjust the shared filters to include more restaurants in these analytics."
                    )
                } else {
                    summaryMetricsGrid
                    scoreOverTimeCard
                    scoreDistributionCard
                    countByMonthCard
                    fryTypeBreakdownCard
                    topRestaurantsCard
                    averageScoreByRestaurantCard
                    countByRestaurantCard
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

            Text(isFiltering ? "Charts are using the current shared filters." : "Score and entry-volume charts across every logged fry rating.")
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

        }
    }

    private var scoreOverTimeCard: some View {
        AnalyticsChartCard(
            title: "Score Over Time",
            subtitle: "Overall scores ordered by entry date.",
            systemImage: "chart.xyaxis.line"
        ) {
            if summary.scoreTrendPoints.count < 2 {
                AnalyticsMissingDataView(
                    title: "Missing Trend Data",
                    message: "Add at least two filtered fry entries to compare scores over time."
                )
            } else {
                ScoreOverTimeChart(points: summary.scoreTrendPoints)
            }
        }
    }

    private var scoreDistributionCard: some View {
        AnalyticsChartCard(
            title: "Score Distribution",
            subtitle: "Entry counts grouped into two-point score buckets.",
            systemImage: "chart.bar"
        ) {
            if summary.scoreDistribution.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Score Data",
                    message: "Scores will appear here as soon as entries are available."
                )
            } else {
                CountBarChart(
                    items: summary.scoreDistribution.map { CountChartItem(label: $0.label, count: $0.count) },
                    xTitle: "Score Range",
                    yTitle: "Entries",
                    horizontal: false
                )
            }
        }
    }

    private var countByMonthCard: some View {
        AnalyticsChartCard(
            title: "Count by Month",
            subtitle: "Monthly entry volume from the selected data set.",
            systemImage: "calendar"
        ) {
            if summary.monthlyEntryCounts.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Date Data",
                    message: "Entry volume will appear once dated entries match the filters."
                )
            } else {
                MonthlyCountChart(items: summary.monthlyEntryCounts)
            }
        }
    }

    private var fryTypeBreakdownCard: some View {
        AnalyticsChartCard(
            title: "Fry Type Breakdown",
            subtitle: "Share of entries by fry cut in the current selection.",
            systemImage: "chart.pie"
        ) {
            if summary.fryTypeBreakdown.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Fry Type Data",
                    message: "Choose fry types on entries to build this pie chart."
                )
            } else {
                FryTypePieChart(items: summary.fryTypeBreakdown, totalCount: summary.entryCount)
            }
        }
    }

    private var topRestaurantsCard: some View {
        AnalyticsChartCard(
            title: "Top Restaurants",
            subtitle: "Highest-scoring restaurant visits in the current selection.",
            systemImage: "list.number"
        ) {
            if summary.topRestaurantVisits.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Restaurant Data",
                    message: "Restaurant rankings will appear once filtered entries include scores."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(summary.topRestaurantVisits) { visit in
                        AnalyticsProgressRow(
                            label: visit.restaurantName,
                            valueText: String(format: "%.1f", visit.score),
                            fraction: visit.score / 10,
                            tint: FryTheme.scoreColor(visit.score),
                            caption: visit.dateLabel
                        )
                    }
                }
            }
        }
    }

    private var averageScoreByRestaurantCard: some View {
        AnalyticsChartCard(
            title: "Average Score by Restaurant",
            subtitle: "Average score for restaurants represented by the active filters.",
            systemImage: "chart.bar.xaxis"
        ) {
            if summary.restaurantScoreSummaries.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Restaurant Data",
                    message: "Average scores need at least one scored restaurant entry."
                )
            } else {
                RestaurantMetricChart(
                    items: summary.restaurantScoreSummaries.map {
                        RestaurantMetricItem(name: $0.name, value: $0.averageScore, annotation: String(format: "%.1f", $0.averageScore))
                    },
                    valueTitle: "Average Score",
                    valueDomain: 0...10,
                    tintForValue: FryTheme.scoreColor
                )
            }
        }
    }

    private var countByRestaurantCard: some View {
        AnalyticsChartCard(
            title: "Count by Restaurant",
            subtitle: "Entry volume ranked by restaurant.",
            systemImage: "chart.bar.doc.horizontal"
        ) {
            if summary.restaurantCountSummaries.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Restaurant Data",
                    message: "Restaurant counts need at least one entry matching the filters."
                )
            } else {
                RestaurantMetricChart(
                    items: summary.restaurantCountSummaries.map {
                        RestaurantMetricItem(name: $0.name, value: Double($0.entryCount), annotation: "\($0.entryCount)")
                    },
                    valueTitle: "Entries",
                    valueDomain: 0...Double(max(summary.maxRestaurantEntryCount, 1)),
                    tintForValue: { _ in FryTheme.fryLight }
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
        bestEntry.map { Self.restaurantName(for: $0) }
    }


    var scoreTrendPoints: [ScoreTrendPoint] {
        entries
            .sorted { $0.date < $1.date }
            .map { entry in
                ScoreTrendPoint(
                    id: entry.id,
                    date: entry.date,
                    score: entry.overallScore
                )
            }
    }

    var scoreDistribution: [ScoreDistributionBucket] {
        let ranges = stride(from: 0, through: 8, by: 2).map { lowerBound in
            ScoreDistributionBucket(
                lowerBound: Double(lowerBound),
                upperBound: Double(lowerBound + 2),
                count: entries.filter { entry in
                    let score = min(max(entry.overallScore, 0), 10)
                    if lowerBound == 8 {
                        return score >= Double(lowerBound) && score <= 10
                    }
                    return score >= Double(lowerBound) && score < Double(lowerBound + 2)
                }.count
            )
        }

        return ranges.filter { $0.count > 0 }
    }

    var monthlyEntryCounts: [MonthlyEntryCount] {
        let groupedEntries = Dictionary(grouping: entries) { entry in
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: entry.date)) ?? entry.date
        }

        return groupedEntries.map { month, monthEntries in
            MonthlyEntryCount(month: month, count: monthEntries.count)
        }
        .sorted { $0.month < $1.month }
    }

    var topRestaurantVisits: [TopRestaurantVisit] {
        entries
            .sorted {
                if $0.overallScore == $1.overallScore {
                    return $0.date > $1.date
                }
                return $0.overallScore > $1.overallScore
            }
            .prefix(5)
            .map { entry in
                TopRestaurantVisit(
                    id: entry.id,
                    restaurantName: Self.restaurantName(for: entry),
                    score: entry.overallScore,
                    dateLabel: Self.shortDateFormatter.string(from: entry.date)
                )
            }
    }

    var restaurantScoreSummaries: [RestaurantScoreSummary] {
        restaurantSummaries.sorted {
            if $0.averageScore == $1.averageScore {
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            return $0.averageScore > $1.averageScore
        }
        .prefix(6)
        .map { $0 }
    }

    var restaurantCountSummaries: [RestaurantScoreSummary] {
        restaurantSummaries.sorted {
            if $0.entryCount == $1.entryCount {
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            return $0.entryCount > $1.entryCount
        }
        .prefix(6)
        .map { $0 }
    }

    var maxRestaurantEntryCount: Int {
        restaurantCountSummaries.map(\.entryCount).max() ?? 0
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

    private var restaurantSummaries: [RestaurantScoreSummary] {
        let groupedEntries = Dictionary(grouping: entries) { Self.restaurantName(for: $0) }

        return groupedEntries.compactMap { name, restaurantEntries in
            guard !restaurantEntries.isEmpty else { return nil }
            let totalScore = restaurantEntries.map(\.overallScore).reduce(0, +)
            return RestaurantScoreSummary(
                name: name,
                averageScore: totalScore / Double(restaurantEntries.count),
                entryCount: restaurantEntries.count
            )
        }
    }

    private static func restaurantName(for entry: FryEntry) -> String {
        let trimmedName = entry.restaurantName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "Unknown Restaurant" : trimmedName
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
    let date: Date
    let score: Double
}

private struct ScoreDistributionBucket: Identifiable {
    var id: String { label }
    let lowerBound: Double
    let upperBound: Double
    let count: Int

    var label: String {
        if upperBound == 10 {
            return "8–10"
        }
        return String(format: "%.0f–%.0f", lowerBound, upperBound)
    }
}

private struct MonthlyEntryCount: Identifiable {
    var id: Date { month }
    let month: Date
    let count: Int
}

private struct TopRestaurantVisit: Identifiable {
    let id: UUID
    let restaurantName: String
    let score: Double
    let dateLabel: String
}

private struct RestaurantScoreSummary: Identifiable {
    var id: String { name }
    let name: String
    let averageScore: Double
    let entryCount: Int
}

private struct RestaurantMetricItem: Identifiable {
    var id: String { name }
    let name: String
    let value: Double
    let annotation: String
}

private struct CountChartItem: Identifiable {
    var id: String { label }
    let label: String
    let count: Int
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

private struct FryTypePieChart: View {
    let items: [FryTypeBreakdownItem]
    let totalCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Chart(items) { item in
                SectorMark(
                    angle: .value("Entries", item.count),
                    innerRadius: .ratio(0.55),
                    angularInset: 2
                )
                .cornerRadius(4)
                .foregroundStyle(fryTypeColor(item.type))
            }
            .frame(height: 240)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                ForEach(items) { item in
                    FryTypeLegendRow(
                        item: item,
                        totalCount: totalCount,
                        color: fryTypeColor(item.type)
                    )
                }
            }
        }
    }
}

private struct FryTypeLegendRow: View {
    let item: FryTypeBreakdownItem
    let totalCount: Int
    let color: Color

    private var percentageText: String {
        guard totalCount > 0 else { return "0%" }
        let percentage = Double(item.count) / Double(totalCount) * 100
        return String(format: "%.0f%%", percentage)
    }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.type.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(FryTheme.text)
                    .lineLimit(1)

                Text("\(item.count) • \(percentageText)")
                    .font(.caption2)
                    .foregroundStyle(FryTheme.mutedText)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ScoreOverTimeChart: View {
    let points: [ScoreTrendPoint]

    var body: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Score", point.score)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(FryTheme.fry)

            PointMark(
                x: .value("Date", point.date),
                y: .value("Score", point.score)
            )
            .foregroundStyle(FryTheme.fryLight)
            .symbolSize(48)
        }
        .chartYScale(domain: 0...10)
        .chartYAxis { analyticsYAxisMarks() }
        .chartXAxis { analyticsXAxisMarks() }
        .frame(height: 220)
    }
}

private struct CountBarChart: View {
    let items: [CountChartItem]
    let xTitle: String
    let yTitle: String
    let horizontal: Bool

    var body: some View {
        Chart(items) { item in
            if horizontal {
                BarMark(
                    x: .value(yTitle, item.count),
                    y: .value(xTitle, item.label)
                )
                .foregroundStyle(FryTheme.fry)
            } else {
                BarMark(
                    x: .value(xTitle, item.label),
                    y: .value(yTitle, item.count)
                )
                .foregroundStyle(FryTheme.fry)
            }
        }
        .chartYAxis { analyticsYAxisMarks() }
        .chartXAxis { analyticsXAxisMarks() }
        .frame(height: 220)
    }
}

private struct MonthlyCountChart: View {
    let items: [MonthlyEntryCount]

    var body: some View {
        Chart(items) { item in
            BarMark(
                x: .value("Month", item.month, unit: .month),
                y: .value("Entries", item.count)
            )
            .foregroundStyle(FryTheme.fryLight)
        }
        .chartYAxis { analyticsYAxisMarks() }
        .chartXAxis { analyticsXAxisMarks() }
        .frame(height: 220)
    }
}

private struct RestaurantMetricChart: View {
    let items: [RestaurantMetricItem]
    let valueTitle: String
    let valueDomain: ClosedRange<Double>
    let tintForValue: (Double) -> Color

    var body: some View {
        Chart(items) { item in
            BarMark(
                x: .value(valueTitle, item.value),
                y: .value("Restaurant", item.name)
            )
            .foregroundStyle(tintForValue(item.value))
            .annotation(position: .trailing, alignment: .leading) {
                Text(item.annotation)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(FryTheme.text)
                    .monospacedDigit()
            }
        }
        .chartXScale(domain: valueDomain)
        .chartYAxis { analyticsYAxisMarks() }
        .chartXAxis { analyticsXAxisMarks() }
        .frame(height: max(180, CGFloat(items.count) * 44))
    }
}

private struct AnalyticsProgressRow: View {
    let label: String
    let valueText: String
    let fraction: Double
    let tint: Color
    var caption: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(FryTheme.text)
                        .lineLimit(1)

                    if let caption {
                        Text(caption)
                            .font(.caption2)
                            .foregroundStyle(FryTheme.mutedText)
                    }
                }
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

private func fryTypeColor(_ type: FryType) -> Color {
    switch type {
    case .shoestring:
        return FryTheme.fryLight
    case .pub:
        return FryTheme.fry
    case .steak:
        return FryTheme.success
    case .waffle:
        return Color(red: 0.98, green: 0.47, blue: 0.18)
    case .curly:
        return Color(red: 0.76, green: 0.44, blue: 0.96)
    case .crinkle:
        return Color(red: 0.38, green: 0.70, blue: 0.98)
    }
}

@AxisContentBuilder
private func analyticsXAxisMarks() -> some AxisContent {
    AxisMarks { _ in
        AxisGridLine()
            .foregroundStyle(FryTheme.cardStroke.opacity(0.45))
        AxisTick()
            .foregroundStyle(FryTheme.cardStroke.opacity(0.8))
        AxisValueLabel()
            .foregroundStyle(FryTheme.mutedText)
    }
}

@AxisContentBuilder
private func analyticsYAxisMarks() -> some AxisContent {
    AxisMarks { _ in
        AxisGridLine()
            .foregroundStyle(FryTheme.cardStroke.opacity(0.45))
        AxisTick()
            .foregroundStyle(FryTheme.cardStroke.opacity(0.8))
        AxisValueLabel()
            .foregroundStyle(FryTheme.mutedText)
    }
}
