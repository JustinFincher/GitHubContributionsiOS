import Foundation

public let numberOfSecondsPerDay: TimeInterval = 60 * 60 * 24
let numberOfSecondsPerMinute: TimeInterval = 60
let numberOfSecondsPerHour: TimeInterval = numberOfSecondsPerMinute * 60

extension Calendar {
    public func fractionalHours(for date: Date) -> Double {
        let dateComponents = self.dateComponents([.hour, .minute, .second], from: date)
        
        let hours = dateComponents.hour ?? 0
        let minutes = dateComponents.minute ?? 0
        let seconds = dateComponents.second ?? 0
        return Double(hours) +
            Double(minutes) / numberOfSecondsPerMinute +
            Double(seconds) / numberOfSecondsPerHour
    }
}
