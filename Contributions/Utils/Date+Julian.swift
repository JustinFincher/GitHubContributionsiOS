import Foundation

// Equal to January 1, 2000, 11:58:55.816 UTC
let _J2000: Date = {
    let gregorian = Calendar(identifier: .gregorian)
    let utc = TimeZone(secondsFromGMT: 0)
    let dateComponents = DateComponents(calendar: gregorian,
                                        timeZone: utc,
                                        year: 2000,
                                        month: 1,
                                        day: 1,
                                        hour: 11,
                                        minute: 58,
                                        second: 55,
                                        nanosecond: 816000000)
    return gregorian.date(from: dateComponents)!
}()

extension Date {
    /// The J2000.0 epoch, 2000-01-01T12:00:00Z
    /// https://en.wikipedia.org/wiki/Epoch_(astronomy)#Julian_years_and_J2000
    public static var J2000: Date {
        return _J2000
    }
}
