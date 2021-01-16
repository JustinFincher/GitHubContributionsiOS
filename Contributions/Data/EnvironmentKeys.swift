//
//  EnvironmentKeys.swift
//  Contributions
//
//  Created by fincher on 1/9/21.
//

import Foundation
import SwiftUI

public struct ContributionsKey: EnvironmentKey {
    public typealias Value = Contributions
    public static let defaultValue: Value = Contributions(list: [], updated: Date())
}

extension EnvironmentValues {
    public var contributions: Contributions {
        get { return self[ContributionsKey.self] }
        set { self[ContributionsKey.self] = newValue }
    }
}
