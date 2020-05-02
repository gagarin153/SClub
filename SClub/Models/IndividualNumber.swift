import Foundation

struct IndividualNumber {
    static func getIndividualNumber() -> String {
        return "#" + String(Int.random(in: 100000..<999999))
    }
}

