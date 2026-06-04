import SwiftUI

struct RatioSlider: View {
    @Binding var value: Int

    // Ratios increment by ~25% steps. Bigger number always listed first regardless of side.
    private static let labels: [Int: String] = [
        -4: "All Crispy",
        -3: "Mostly Crispy (4:1)",
        -2: "More Crispy (2:1)",
        -1: "Slightly Crispy (4:3)",
         0: "Even Split",
         1: "Slightly Floppy (4:3)",
         2: "More Floppy (2:1)",
         3: "Mostly Floppy (4:1)",
         4: "All Floppy"
    ]

    private var doubleBinding: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { value = Int($0.rounded()) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("Crispy to Floppy Ratio")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(FryTheme.text)
                Spacer()
                Text(Self.labels[value] ?? "Even Split")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(FryTheme.fryLight)
                    .multilineTextAlignment(.trailing)
            }
            HStack(spacing: 8) {
                Text("All Crispy")
                    .font(.caption2)
                    .foregroundStyle(FryTheme.mutedText)
                    .frame(width: 58, alignment: .leading)
                Slider(value: doubleBinding, in: -4...4, step: 1)
                    .tint(FryTheme.fry)
                Text("All Floppy")
                    .font(.caption2)
                    .foregroundStyle(FryTheme.mutedText)
                    .frame(width: 58, alignment: .trailing)
            }
        }
        .padding(12)
        .background(FryTheme.cardElevated.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
