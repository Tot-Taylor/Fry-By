import Foundation

// Input value type consumed by any FryScoringStrategy.
// Keeps scoring decoupled from the SwiftData model.
struct FryRatingInput {
    let undippedFlavor: Int
    let appearance: Int
    let hungerLevel: Int
    let temperature: FryTemperature
    let starchiness: Int
    let crispyFloppyRatio: Int
    let ketchupFlavor: Int?
    let signatureSauceFlavor: Int?
    let dunkability: Int?
    let extraSeasoning: Int?
    let crispyQuality: Int?
    let floppyQuality: Int?
}

// Implement this protocol to replace the scoring algorithm.
// Assign the new implementation to FryScorer.strategy.
protocol FryScoringStrategy {
    func calculate(_ input: FryRatingInput) -> Double
}

// Static entrypoint. Swap `strategy` to change the algorithm at runtime.
enum FryScorer {
    static var strategy: FryScoringStrategy = DefaultFryScorer()

    static func score(_ input: FryRatingInput) -> Double {
        strategy.calculate(input)
    }
}

extension FryEntry {
    var ratingInput: FryRatingInput {
        FryRatingInput(
            undippedFlavor: undippedFlavor,
            appearance: appearance,
            hungerLevel: hungerLevel,
            temperature: temperature,
            starchiness: starchiness,
            crispyFloppyRatio: crispyFloppyRatio,
            ketchupFlavor: ketchupFlavor,
            signatureSauceFlavor: signatureSauceFlavor,
            dunkability: dunkability,
            extraSeasoning: extraSeasoning,
            crispyQuality: crispyQuality,
            floppyQuality: floppyQuality
        )
    }
}
