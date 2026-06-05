import SwiftUI

enum FryTheme {
    static let background = Color(red: 0.03, green: 0.035, blue: 0.04)
    static let backgroundGlow = Color(red: 0.16, green: 0.10, blue: 0.03)
    static let card = Color(red: 0.11, green: 0.10, blue: 0.08)
    static let cardElevated = Color(red: 0.16, green: 0.13, blue: 0.09)
    static let cardStroke = Color(red: 0.31, green: 0.22, blue: 0.10)
    static let fry = Color(red: 0.96, green: 0.63, blue: 0.02)
    static let fryLight = Color(red: 1.00, green: 0.82, blue: 0.42)
    static let text = Color(red: 1.00, green: 0.96, blue: 0.86)
    static let mutedText = Color(red: 0.72, green: 0.66, blue: 0.56)
    static let danger = Color(red: 0.98, green: 0.32, blue: 0.24)
    static let success = Color(red: 0.35, green: 0.82, blue: 0.41)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundGlow, background, Color.black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var fryGradient: LinearGradient {
        LinearGradient(
            colors: [fryLight, fry, Color(red: 0.78, green: 0.38, blue: 0.00)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func scoreColor(_ score: Double) -> Color {
        switch score {
        case 8...: return success
        case 6..<8: return fryLight
        case 4..<6: return fry
        default: return danger
        }
    }

    static func ratingColor(_ value: Int) -> Color {
        switch value {
        case 8...10: return success
        case 5..<8: return fryLight
        case 3..<5: return fry
        default: return danger
        }
    }
}

struct FryBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(FryTheme.backgroundGradient.ignoresSafeArea())
            .environment(\.colorScheme, .dark)
            .foregroundStyle(FryTheme.text)
            .tint(FryTheme.fry)
    }
}

extension View {
    func fryBackground() -> some View {
        modifier(FryBackground())
    }

    func fryCardStyle() -> some View {
        padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(FryTheme.card.opacity(0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(FryTheme.cardStroke.opacity(0.8), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 12)
            )
    }
}

struct FrySectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.2)
                .foregroundStyle(FryTheme.fryLight)

            VStack(alignment: .leading, spacing: 14) {
                content
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fryCardStyle()
    }
}

struct FryDivider: View {
    var body: some View {
        Rectangle()
            .fill(FryTheme.cardStroke.opacity(0.55))
            .frame(height: 1)
    }
}
