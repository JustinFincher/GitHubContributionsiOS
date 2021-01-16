//
//  Date+Comp.swift
//  Contributions
//
//  Created by fincher on 1/9/21.
//

import Foundation

extension Date {
    var veryShortMonthString: String {
        let index = Calendar.autoupdatingCurrent.component(.month, from: self)
        return Calendar.autoupdatingCurrent.veryShortMonthSymbols[index - 1]
    }
    
    var shortMonthString: String {
        let index = Calendar.autoupdatingCurrent.component(.month, from: self)
        return Calendar.autoupdatingCurrent.shortMonthSymbols[index - 1]
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
