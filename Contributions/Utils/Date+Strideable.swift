import Foundation

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return self.timeIntervalSinceReferenceDate - other.timeIntervalSinceReferenceDate
    }
    
    public func advanced(by n: TimeInterval) -> Date {
        return self.addingTimeInterval(n)
    }
}
