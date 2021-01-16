//
//  BundleExtension.swift
//  Dynamic
//
//  Created by Fincher on 12/8/20.
//

import Foundation
extension Bundle {
    var versionString: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildString: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
