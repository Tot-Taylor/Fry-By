import Foundation

// Initial scoring algorithm. All scoring logic lives here exclusively.
//
// TO TUNE WEIGHTS: Edit the values in the Weights enum below.
// TO REPLACE THE ALGORITHM: Create a new FryScoringStrategy and assign it to FryScorer.strategy.
//
// Weights below are provisional placeholders. Adjust based on real usage.
struct DefaultFryScorer: FryScoringStrategy {

    private enum Weights {
        // Required fields
        static let undippedFlavor:    Double = 0.20
        static let appearance:        Double = 0.10
        static let starchiness:       Double = 0.08
        static let crispyFloppyRatio: Double = 0.05
        static let temperature:       Double = 0.05
        static let hungerLevel:       Double = 0.05
        // Nullable — only included when the user provided a value.
        // Missing weights are redistributed proportionally across filled fields.
        static let ketchupFlavor:         Double = 0.08
        static let signatureSauceFlavor:  Double = 0.10
        static let dunkability:           Double = 0.07
        static let extraSeasoning:        Double = 0.07
        static let crispyQuality:         Double = 0.08
        static let floppyQuality:         Double = 0.07
    }

    func calculate(_ input: FryRatingInput) -> Double {
        var components: [(score: Double, weight: Double)] = []

        components.append((norm10(input.undippedFlavor),    Weights.undippedFlavor))
        components.append((norm10(input.appearance),        Weights.appearance))
        components.append((normSpectrum(input.starchiness), Weights.starchiness))
        components.append((normSpectrum(input.crispyFloppyRatio), Weights.crispyFloppyRatio))
        components.append((tempScore(input.temperature),    Weights.temperature))
        components.append((norm10(input.hungerLevel),       Weights.hungerLevel))

        if let v = input.ketchupFlavor        { components.append((norm10(v),         Weights.ketchupFlavor)) }
        if let v = input.signatureSauceFlavor { components.append((norm10(v),         Weights.signatureSauceFlavor)) }
        if let v = input.dunkability          { components.append((norm10(v),         Weights.dunkability)) }
        if let v = input.extraSeasoning       { components.append((norm10(v),         Weights.extraSeasoning)) }
        if let v = input.crispyQuality        { components.append((normSpectrum(v),   Weights.crispyQuality)) }
        if let v = input.floppyQuality        { components.append((normSpectrum(v),   Weights.floppyQuality)) }

        let totalWeight = components.reduce(0.0) { $0 + $1.weight }
        guard totalWeight > 0 else { return 0 }

        let weightedSum = components.reduce(0.0) { $0 + $1.score * $1.weight }
        return (weightedSum / totalWeight) * 10.0
    }

    // Normalizes a 1–10 integer to 0–1.
    private func norm10(_ value: Int) -> Double {
        Double(value - 1) / 9.0
    }

    // Normalizes a spectrum value (–4 to +4) where 0 is ideal.
    // Maximum distance (±4) yields a score of 0; center (0) yields 1.
    private func normSpectrum(_ value: Int) -> Double {
        1.0 - Double(abs(value)) / 4.0
    }

    // Maps temperature to a 0–1 score. Hot is considered optimal.
    private func tempScore(_ temp: FryTemperature) -> Double {
        switch temp {
        case .frozen:          return 0.00
        case .cold:            return 0.15
        case .roomTemperature: return 0.30
        case .lukewarm:        return 0.50
        case .warm:            return 0.70
        case .hot:             return 1.00
        case .pipingHot:       return 0.90
        }
    }
}
