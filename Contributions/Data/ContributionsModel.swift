//
//  ContributionsModel.swift
//  Contributions
//
//  Created by fincher on 1/8/21.
//

import Foundation
import SwiftUI
import UIKit

public struct Contribution : Codable, Hashable {
    var date : Date
    var dateRawString : String
    var count : Int
    var fillRawString : String
    func getColor(color: ColorScheme) -> Color {
        if count <= 0 {
            return Color.init(color == .light ? "#ebedf0".hexStringToUIColor() : "#161b22".hexStringToUIColor())
        } else if count < 10
        {
            return Color.init(color == .light ? "#9be9a8".hexStringToUIColor() : "#01311f".hexStringToUIColor())
        } else if count < 15
        {
            return Color.init(color == .light ? "#40c463".hexStringToUIColor() : "#034525".hexStringToUIColor())
        } else if count < 20
        {
            return Color.init(color == .light ? "#30a14e".hexStringToUIColor() : "#0f6d31".hexStringToUIColor())
        }else
        {
            return Color.init(color == .light ? "#216e39".hexStringToUIColor() : "#00c647".hexStringToUIColor())
        }
    }
}

public struct Contributions : Codable {
    var list : [Contribution]
    var updated : Date
    
    var commitsCount: Int {
        list.reduce(0, { (res, c) in
            res + c.count
        })
    }
    
    var dayCount: Int {
        list.count
    }
    
    var streak: [[Contribution]] {
        let gapped = list.reduce([[Contribution]]()) { (current : [[Contribution]], next : Contribution) -> [[Contribution]] in
            var result = current
            if next.count > 0
            {
                if var last : [Contribution] = result.last
                {
                    if let lastLast : Contribution = last.last,
                       lastLast.count > 0
                    {
                        last.append(next)
                        result[result.count - 1] = last
                    } else {
                        result.append([next])
                    }
                } else {
                    result.append([next])
                }
            }
            else {
                result.append([next])
            }
            return result
        }
        return gapped
    }
    
    var currentStreak: Int {
        if let last = streak.last {
            if let lastLast = last.last, lastLast.count == 0
            {
                 return 0
            } else {
                return last.count
            }
        }
        return 0
    }
    
    var longestStreak: Int {
        streak.map { arr -> Int in
            arr.count
        }.max() ?? 0
    }
    
    var commitsAverage: Float {
        Float(commitsCount) / Float(dayCount)
    }
    
    var commitsMostInADay: Int {
        list.map { c in
            c.count
        }.sorted().last ?? 0
    }
    
    var listFillingWeekDays: [Contribution] {
        var sorted = list.sorted { (c1, c2) -> Bool in
            c1.date.compare(c2.date) == .orderedDescending
        }
        if let firstDay : Contribution = sorted.first
        {
            let weekDay = Calendar.autoupdatingCurrent.component(.weekday, from: firstDay.date)
            for addingDay in 1..<(8-weekDay)
            {
                if let addingDate : Date = Calendar.autoupdatingCurrent.date(byAdding: .day, value: addingDay, to: firstDay.date) {
                    sorted.insert(Contribution(date: addingDate, dateRawString: "", count: 0, fillRawString: ""), at: 0)
                }
            }
        }
        if let lastDay : Contribution = sorted.last
        {
            let weekDay = Calendar.autoupdatingCurrent.component(.weekday, from: lastDay.date)
            for addingDay in (-weekDay + 1 ..< 0).reversed()
            {
                if let addingDate : Date = Calendar.autoupdatingCurrent.date(byAdding: .day, value: addingDay, to: lastDay.date) {
                    sorted.append(Contribution(date: addingDate, dateRawString: "", count: 0, fillRawString: ""))
                }
            }
        }
        return sorted
    }
    
    var twoDListFillingWeekDays : [[Contribution]] {
        listFillingWeekDays.chunked(into: 7)
    }
}

public struct UserContributions : Codable {
    var dict : [String : Contributions]
    
    func hasUser(name: String) -> Bool {
        dict.keys.contains(name)
    }
    
    func contributionsFor(name: String) -> Contributions? {
        hasUser(name: name) ? dict[name] : nil
    }
    
    func generateSampleData() -> (String, Contributions) {
        let today : Date = Date()
        var list : [Contribution] = []
        for i in (1...365)
        {
            list.append(Contribution(date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: -i, to: today)!, dateRawString: "", count: max(0, Int.random(in: -20..<20)), fillRawString: ""))
        }
        return ("UserName", Contributions(list: list, updated: Date()))
    }
}
