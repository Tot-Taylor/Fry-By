import Foundation
import SwiftData

@Model
final class FryEntry {
    @Attribute(.unique) var id: UUID
    var restaurantName: String
    var date: Date
    var notes: String?
    var fryType: FryType
    var temperature: FryTemperature
    var hungerLevel: Int
    var appearance: Int
    var undippedFlavor: Int
    var ketchupFlavor: Int?
    var signatureSauceFlavor: Int?
    var signatureSauceName: String?
    var dunkability: Int?
    var extraSeasoning: Int?
    var extraSeasoningName: String?
    var starchiness: Int        // –4 to +4; 0 = perfect
    var crispyFloppyRatio: Int  // –4 = all crispy, 0 = even split, +4 = all floppy
    var crispyQuality: Int?     // –4 to +4; 0 = perfectly crispy
    var floppyQuality: Int?     // –4 to +4; 0 = perfectly floppy
    var overallScore: Double    // computed at save time via FryScorer

    init(
        restaurantName: String,
        date: Date = .now,
        notes: String? = nil,
        fryType: FryType,
        temperature: FryTemperature,
        hungerLevel: Int,
        appearance: Int,
        undippedFlavor: Int,
        ketchupFlavor: Int? = nil,
        signatureSauceFlavor: Int? = nil,
        signatureSauceName: String? = nil,
        dunkability: Int? = nil,
        extraSeasoning: Int? = nil,
        extraSeasoningName: String? = nil,
        starchiness: Int,
        crispyFloppyRatio: Int,
        crispyQuality: Int? = nil,
        floppyQuality: Int? = nil,
        overallScore: Double
    ) {
        self.id = UUID()
        self.restaurantName = restaurantName
        self.date = date
        self.notes = notes
        self.fryType = fryType
        self.temperature = temperature
        self.hungerLevel = hungerLevel
        self.appearance = appearance
        self.undippedFlavor = undippedFlavor
        self.ketchupFlavor = ketchupFlavor
        self.signatureSauceFlavor = signatureSauceFlavor
        self.signatureSauceName = signatureSauceName
        self.dunkability = dunkability
        self.extraSeasoning = extraSeasoning
        self.extraSeasoningName = extraSeasoningName
        self.starchiness = starchiness
        self.crispyFloppyRatio = crispyFloppyRatio
        self.crispyQuality = crispyQuality
        self.floppyQuality = floppyQuality
        self.overallScore = overallScore
    }
}
