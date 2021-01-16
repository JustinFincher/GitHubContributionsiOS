import Foundation

extension DateInterval {
    public func striding(by timeInterval: TimeInterval) -> StrideTo<Date> {
        return stride(from: self.start, to: self.end, by: timeInterval)
    }
}
