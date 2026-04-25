import SwiftUI

struct RatioSlider: View {
    @Binding var value: Int

    private static let labels: [Int: String] = [
        -4: "All Crispy (5:0)",
        -3: "Mostly Crispy (4:1)",
        -2: "More Crispy (3:2)",
        -1: "Slightly More Crispy",
         0: "Even Split (1:1)",
         1: "Slightly More Floppy",
         2: "More Floppy (2:3)",
         3: "Mostly Floppy (1:4)",
         4: "All Floppy (0:5)"
    ]

    private var doubleBinding: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { value = Int($0.rounded()) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Crispy:Floppy Ratio")
                    .font(.subheadline)
                Spacer()
                Text(Self.labels[value] ?? "Even Split (1:1)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(value == 0 ? Color.green : Color.primary)
            }
            HStack(spacing: 8) {
                Text("All Crispy")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 58, alignment: .leading)
                Slider(value: doubleBinding, in: -4...4, step: 1)
                Text("All Floppy")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 58, alignment: .trailing)
            }
        }
        .padding(.vertical, 2)
    }
}
