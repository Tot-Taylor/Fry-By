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
                    overallScoreSnapshotCard
                    scoreOverTimeCard
                    scoreDistributionCard
                    countByMonthCard
                    fryTypeBreakdownCard
                    temperatureBreakdownCard
                    fieldAverageScoresCard
                    textureBalanceCard
                    if !summary.sauceAndSeasoningCounts.isEmpty {
                        sauceAndSeasoningCard
                    }
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

    private var overallScoreSnapshotCard: some View {
        AnalyticsChartCard(
            title: "Overall Score Snapshot",
            subtitle: "Average overall score for the current selection, with the best score called out.",
            systemImage: "gauge.with.dots.needle.67percent"
        ) {
            if let averageScore = summary.averageScore {
                AverageScoreGauge(
                    averageScore: averageScore,
                    bestScore: summary.bestEntry?.overallScore,
                    entryCount: summary.entryCount
                )
            } else {
                AnalyticsMissingDataView(
                    title: "Missing Score Data",
                    message: "Overall score analytics will appear as soon as entries match the filters."
                )
            }
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

    private var temperatureBreakdownCard: some View {
        AnalyticsChartCard(
            title: "Temperature Breakdown",
            subtitle: "Count of user-entered temperature selections for matching entries.",
            systemImage: "thermometer.medium"
        ) {
            if summary.temperatureBreakdown.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Temperature Data",
                    message: "Temperature selections will appear once entries match the filters."
                )
            } else {
                CountBarChart(
                    items: summary.temperatureBreakdown.map { CountChartItem(label: $0.temperature.rawValue, count: $0.count) },
                    xTitle: "Temperature",
                    yTitle: "Entries",
                    horizontal: true
                )
            }
        }
    }

    private var fieldAverageScoresCard: some View {
        AnalyticsChartCard(
            title: "Average Entered Ratings",
            subtitle: "Average 1–10 values for manually entered rating fields with available data.",
            systemImage: "slider.horizontal.3"
        ) {
            if summary.averageRatingFields.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Rating Data",
                    message: "Rating-field averages will appear once entries match the filters."
                )
            } else {
                RatingAverageChart(items: summary.averageRatingFields)
            }
        }
    }

    private var textureBalanceCard: some View {
        AnalyticsChartCard(
            title: "Crispy vs. Floppy Balance",
            subtitle: "Distribution of the user-entered crispy/floppy ratio field.",
            systemImage: "circle.lefthalf.filled"
        ) {
            if summary.crispyFloppyBreakdown.isEmpty {
                AnalyticsMissingDataView(
                    title: "Missing Texture Data",
                    message: "Texture ratio counts will appear once entries match the filters."
                )
            } else {
                CountBarChart(
                    items: summary.crispyFloppyBreakdown,
                    xTitle: "Texture Ratio",
                    yTitle: "Entries",
                    horizontal: true
                )
            }
        }
    }

    private var sauceAndSeasoningCard: some View {
        AnalyticsChartCard(
            title: "Sauces & Seasonings",
            subtitle: "Most-used custom sauce and seasoning names entered on ratings.",
            systemImage: "takeoutbag.and.cup.and.straw"
        ) {
            CountBarChart(
                items: summary.sauceAndSeasoningCounts,
                xTitle: "Name",
                yTitle: "Entries",
                horizontal: true
            )
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

    var temperatureBreakdown: [TemperatureBreakdownItem] {
        FryTemperature.allCases.compactMap { temperature in
            let count = entries.filter { $0.temperature == temperature }.count
            guard count > 0 else { return nil }
            return TemperatureBreakdownItem(temperature: temperature, count: count)
        }
        .sorted {
            if $0.count == $1.count {
                return $0.temperature.rawValue < $1.temperature.rawValue
            }
            return $0.count > $1.count
        }
    }

    var averageRatingFields: [RatingAverageItem] {
        [
            ratingAverage(label: "Undipped Flavor", values: entries.map(\.undippedFlavor)),
            ratingAverage(label: "Appearance", values: entries.map(\.appearance)),
            ratingAverage(label: "Hunger Level", values: entries.map(\.hungerLevel)),
            optionalRatingAverage(label: "Ketchup Flavor", values: entries.compactMap(\.ketchupFlavor)),
            optionalRatingAverage(label: "Other Sauce Flavor", values: entries.compactMap(\.signatureSauceFlavor)),
            optionalRatingAverage(label: "Sauce Retention", values: entries.compactMap(\.dunkability)),
            optionalRatingAverage(label: "Extra Seasoning", values: entries.compactMap(\.extraSeasoning))
        ]
        .compactMap { $0 }
        .sorted {
            if $0.average == $1.average {
                return $0.label < $1.label
            }
            return $0.average > $1.average
        }
    }

    var crispyFloppyBreakdown: [CountChartItem] {
        let groupedEntries = Dictionary(grouping: entries) { Self.crispyFloppyLabel(for: $0.crispyFloppyRatio) }

        return groupedEntries.map { label, ratioEntries in
            CountChartItem(label: label, count: ratioEntries.count)
        }
        .sorted {
            if $0.count == $1.count {
                return $0.label < $1.label
            }
            return $0.count > $1.count
        }
    }

    var sauceAndSeasoningCounts: [CountChartItem] {
        var names: [String] = []

        for entry in entries {
            if let sauceName = Self.trimmedText(entry.signatureSauceName), entry.signatureSauceFlavor != nil {
                names.append("Sauce: \(sauceName)")
            }

            if let seasoningName = Self.trimmedText(entry.extraSeasoningName), entry.extraSeasoning != nil {
                names.append("Seasoning: \(seasoningName)")
            }
        }

        let groupedNames = Dictionary(grouping: names, by: { $0 })

        return groupedNames.map { name, values in
            CountChartItem(label: name, count: values.count)
        }
        .sorted {
            if $0.count == $1.count {
                return $0.label < $1.label
            }
            return $0.count > $1.count
        }
        .prefix(6)
        .map { $0 }
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

    private func ratingAverage(label: String, values: [Int]) -> RatingAverageItem? {
        guard !values.isEmpty else { return nil }
        let average = Double(values.reduce(0, +)) / Double(values.count)
        return RatingAverageItem(label: label, average: average, entryCount: values.count)
    }

    private func optionalRatingAverage(label: String, values: [Int]) -> RatingAverageItem? {
        guard values.count >= 2 || values.count == entries.count else { return nil }
        return ratingAverage(label: label, values: values)
    }

    private static func restaurantName(for entry: FryEntry) -> String {
        let trimmedName = entry.restaurantName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "Unknown Restaurant" : trimmedName
    }

    private static func trimmedText(_ text: String?) -> String? {
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmedText.isEmpty ? nil : trimmedText
    }

    private static func crispyFloppyLabel(for ratio: Int) -> String {
        switch ratio {
        case -4: return "All Crispy"
        case -3: return "Mostly Crispy"
        case -2: return "More Crispy"
        case -1: return "Slightly Crispy"
        case 0: return "Even Split"
        case 1: return "Slightly Floppy"
        case 2: return "More Floppy"
        case 3: return "Mostly Floppy"
        case 4: return "All Floppy"
        default: return "Even Split"
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

private struct TemperatureBreakdownItem: Identifiable {
    var id: FryTemperature { temperature }
    let temperature: FryTemperature
    let count: Int
}

private struct RatingAverageItem: Identifiable {
    var id: String { label }
    let label: String
    let average: Double
    let entryCount: Int
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

private struct AverageScoreGauge: View {
    let averageScore: Double
    let bestScore: Double?
    let entryCount: Int

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            ZStack {
                Circle()
                    .stroke(FryTheme.cardStroke.opacity(0.75), lineWidth: 18)

                Circle()
                    .trim(from: 0, to: min(max(averageScore / 10, 0), 1))
                    .stroke(
                        FryTheme.scoreColor(averageScore),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text(String(format: "%.1f", averageScore))
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(FryTheme.scoreColor(averageScore))
                        .monospacedDigit()
                    Text("AVG / 10")
                        .font(.caption2.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(FryTheme.mutedText)
                }
            }
            .frame(width: 150, height: 150)

            VStack(alignment: .leading, spacing: 10) {
                AnalyticsProgressRow(
                    label: "Average Overall",
                    valueText: String(format: "%.1f", averageScore),
                    fraction: averageScore / 10,
                    tint: FryTheme.scoreColor(averageScore),
                    caption: "Across \(entryCount) \(entryCount == 1 ? "entry" : "entries")"
                )

                if let bestScore {
                    AnalyticsProgressRow(
                        label: "Best Overall",
                        valueText: String(format: "%.1f", bestScore),
                        fraction: bestScore / 10,
                        tint: FryTheme.scoreColor(bestScore),
                        caption: "Highest selected score"
                    )
                }
            }
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

private struct RatingAverageChart: View {
    let items: [RatingAverageItem]

    var body: some View {
        Chart(items) { item in
            BarMark(
                x: .value("Average Rating", item.average),
                y: .value("Field", item.label)
            )
            .foregroundStyle(FryTheme.ratingColor(Int(item.average.rounded())))
            .annotation(position: .trailing, alignment: .leading) {
                Text(String(format: "%.1f (n=%d)", item.average, item.entryCount))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(FryTheme.text)
                    .monospacedDigit()
            }
        }
        .chartXScale(domain: 0...10)
        .chartYAxis { analyticsYAxisMarks() }
        .chartXAxis { analyticsXAxisMarks() }
        .frame(height: max(220, CGFloat(items.count) * 38))
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
