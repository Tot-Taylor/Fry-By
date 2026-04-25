import SwiftUI

struct RatingSlider: View {
    let title: String
    @Binding var value: Int
    var leftLabel: String? = nil
    var rightLabel: String? = nil

    private var doubleBinding: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { value = Int($0.rounded()) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text("\(value) / 10")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(ratingColor(value))
                    .monospacedDigit()
            }
            if leftLabel != nil || rightLabel != nil {
                HStack(spacing: 8) {
                    Text(leftLabel ?? "")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(width: 58, alignment: .leading)
                    Slider(value: doubleBinding, in: 1...10, step: 1)
                        .tint(ratingColor(value))
                    Text(rightLabel ?? "")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(width: 58, alignment: .trailing)
                }
            } else {
                Slider(value: doubleBinding, in: 1...10, step: 1)
                    .tint(ratingColor(value))
            }
        }
        .padding(.vertical, 2)
    }

    private func ratingColor(_ v: Int) -> Color {
        switch v {
        case 8...10: return .green
        case 5..<8:  return .yellow
        case 3..<5:  return .orange
        default:     return .red
        }
    }
}
