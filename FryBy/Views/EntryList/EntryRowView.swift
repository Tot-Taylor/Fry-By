import SwiftUI

struct EntryRowView: View {
    let entry: FryEntry

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(entry.restaurantName)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(entry.fryType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.yellow.opacity(0.3))
                        .clipShape(Capsule())
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 1) {
                Text(String(format: "%.1f", entry.overallScore))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(scoreColor(entry.overallScore))
                    .monospacedDigit()
                Text("/ 10")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 8...: return .green
        case 6..<8: return .yellow
        case 4..<6: return .orange
        default: return .red
        }
    }
}
