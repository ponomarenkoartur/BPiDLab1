import Foundation

extension Int {
    public func getMultiple(greaterThan lowerBound: Int) -> Int {
        var number = lowerBound
        repeat {
            number += 1
        } while (number % self != 0)
        return number
    }
    
    public static func getMultiple(of divider: Int, greaterThan lowerBound: Int) -> Int {
        var number = lowerBound
        repeat {
            number += 1
        } while (number % divider != 0)
        return number
    }
}
