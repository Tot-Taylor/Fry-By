import Foundation

enum FryTemperature: String, CaseIterable, Codable {
    case frozen          = "Frozen"
    case cold            = "Cold"
    case roomTemperature = "Room Temperature"
    case lukewarm        = "Lukewarm"
    case warm            = "Warm"
    case hot             = "Hot"
    case pipingHot       = "Piping Hot"
}
