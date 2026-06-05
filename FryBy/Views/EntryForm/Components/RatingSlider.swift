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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(FryTheme.text)
                Spacer()
                Text("\(value) / 10")
                    .font(.subheadline)
                    .fontWeight(.black)
                    .foregroundStyle(FryTheme.ratingColor(value))
                    .monospacedDigit()
            }
            if leftLabel != nil || rightLabel != nil {
                HStack(spacing: 8) {
                    Text(leftLabel ?? "")
                        .font(.caption2)
                        .foregroundStyle(FryTheme.mutedText)
                        .frame(width: 58, alignment: .leading)
                    Slider(value: doubleBinding, in: 1...10, step: 1)
                        .tint(FryTheme.ratingColor(value))
                    Text(rightLabel ?? "")
                        .font(.caption2)
                        .foregroundStyle(FryTheme.mutedText)
                        .frame(width: 58, alignment: .trailing)
                }
            } else {
                Slider(value: doubleBinding, in: 1...10, step: 1)
                    .tint(FryTheme.ratingColor(value))
            }
        }
        .padding(12)
        .background(FryTheme.cardElevated.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
