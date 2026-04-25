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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text(currentLabel)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(value == 0 ? Color.green : Color.primary)
            }
            HStack(spacing: 8) {
                Text(negativeLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 70, alignment: .leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Slider(value: doubleBinding, in: -4...4, step: 1)
                Text(positiveLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 70, alignment: .trailing)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.vertical, 2)
    }

    private var currentLabel: String {
        if value == 0 { return "Perfect" }
        let label = value < 0 ? negativeLabel : positiveLabel
        let sign = value > 0 ? "+" : ""
        return "\(label) (\(sign)\(value))"
    }
}
