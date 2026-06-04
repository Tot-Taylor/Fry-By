import SwiftUI

struct SpectrumSlider: View {
    let title: String
    @Binding var value: Int
    let negativeLabel: String
    let positiveLabel: String

    private var doubleBinding: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { value = Int($0.rounded()) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(FryTheme.text)
                Spacer()
                Text(currentLabel)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(value == 0 ? FryTheme.success : FryTheme.fryLight)
                    .multilineTextAlignment(.trailing)
            }
            HStack(spacing: 8) {
                Text(negativeLabel)
                    .font(.caption2)
                    .foregroundStyle(FryTheme.mutedText)
                    .frame(width: 70, alignment: .leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Slider(value: doubleBinding, in: -4...4, step: 1)
                    .tint(value == 0 ? FryTheme.success : FryTheme.fry)
                Text(positiveLabel)
                    .font(.caption2)
                    .foregroundStyle(FryTheme.mutedText)
                    .frame(width: 70, alignment: .trailing)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(12)
        .background(FryTheme.cardElevated.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var currentLabel: String {
        if value == 0 { return "Perfect" }
        let label = value < 0 ? negativeLabel : positiveLabel
        let sign = value > 0 ? "+" : ""
        return "\(label) (\(sign)\(value))"
    }
}
