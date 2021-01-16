//
//  File.swift
//  WatchExt Extension
//
//  Created by fincher on 1/11/21.
//

import Foundation
import WatchKit
import Kingfisher

class ContributionsAppDelegate: NSObject, WKExtensionDelegate
{
    func applicationDidFinishLaunching() {
        
        Kingfisher.ImageCache.default.memoryStorage.config.totalCostLimit = 10 * 1024 * 1024
        Kingfisher.ImageCache.default.diskStorage.config.sizeLimit = 20 * 1024 * 1024
        RuntimeManager.shared.spawn()
    }
}
