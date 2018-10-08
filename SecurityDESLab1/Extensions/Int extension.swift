import Foundation

extension Int {
    public func getMultiple(greaterThan lowerBound: Int) -> Int {
        var number = lowerBound
        while (number % self != 0) {
            number += 1
        }
        return number
    }
}
