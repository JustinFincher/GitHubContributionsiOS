//
//  PerferenceManager.swift
//  Dynamic
//
//  Created by Fincher on 12/9/20.
//

import Foundation

class PreferenceManager : RuntimeManagableSingleton
{
    static let shared: PreferenceManager = {
        let instance = PreferenceManager()
        return instance
    }()
    
    override class func setup() {
        print("PreferenceManager.setup")
        print("Cloud available \(PreferenceManager.shared.cloudAvailable)")
    }
    
    public var cloudAvailable: Bool {
        return FileManager.default.ubiquityIdentityToken != nil
    }
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
        #if !os(watchOS)
        NotificationCenter.default.addObserver(self, selector: #selector(cloudUserDefaultsDidChange), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        #if !os(watchOS)
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        #endif
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification)
    {
    }
    
    let userDefault: UserDefaults = UserDefaults(suiteName: ContributionsAppInfo.appGroup) ?? UserDefaults.standard
    
    func exportUserDefaultDict() -> [String : Any] {
        userDefault.dictionaryWithValues(forKeys: [
            "selectedUserName",
            "userNames",
            "userContributions"
        ])
    }
    
    func importUserDefaultDict(dict: [String : Any]) -> Void {
        dict.forEach { (k: String, v: Any) in
            userDefault.setValue(v, forKey: k)
        }
    }
    
    #if !os(watchOS)
    let cloudUserDefault : NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
    @objc func cloudUserDefaultsDidChange(_ notification: Notification)
    {
        
    }
    #endif
    

}
