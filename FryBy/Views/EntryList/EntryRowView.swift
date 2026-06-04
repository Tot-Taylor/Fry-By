import SwiftUI

struct EntryRowView: View {
    let entry: FryEntry

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.restaurantName)
                    .font(.headline)
                    .foregroundStyle(FryTheme.text)
                HStack(spacing: 6) {
                    Text(entry.fryType.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(FryTheme.fry.opacity(0.24))
                        .foregroundStyle(FryTheme.fryLight)
                        .clipShape(Capsule())
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(FryTheme.mutedText)
                }
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(FryTheme.cardStroke.opacity(0.75), lineWidth: 5)
                Circle()
                    .trim(from: 0, to: min(max(entry.overallScore / 10, 0), 1))
                    .stroke(
                        FryTheme.scoreColor(entry.overallScore),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 0) {
                    Text(String(format: "%.1f", entry.overallScore))
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundStyle(FryTheme.scoreColor(entry.overallScore))
                        .monospacedDigit()
                    Text("/ 10")
                        .font(.caption2)
                        .foregroundStyle(FryTheme.mutedText)
                }
            }
            .frame(width: 70, height: 70)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(FryTheme.card.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(FryTheme.cardStroke.opacity(0.75), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.32), radius: 14, x: 0, y: 9)
        )
    }
}
