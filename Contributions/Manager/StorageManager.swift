//
//  StorageManager.swift
//  Contributions
//
//  Created by fincher on 1/12/21.
//

import Foundation

class StorageManager : RuntimeManagableSingleton
{
    static let shared: StorageManager = {
        let instance = StorageManager()
        return instance
    }()
    
    let fileManager : FileManager
    override private init() {
        fileManager = FileManager.default
    }
    
    override class func setup() {
        print("StorageManager.setup")
    }
    
    var appGroupURL: URL? {
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: ContributionsAppInfo.appGroup)
    }
    var appGroupDocumentsURL :URL?
    {
        appGroupURL?.appendingPathComponent("Documents", isDirectory: true)
    }
    var localDocumentsURL :URL?
    {
        let urls : [URL] = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.count > 0 ? urls[0] : nil
    }
}
