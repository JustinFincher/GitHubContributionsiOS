//
//  Comparable+Math.swift
//  Contributions
//
//  Created by fincher on 1/8/21.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
