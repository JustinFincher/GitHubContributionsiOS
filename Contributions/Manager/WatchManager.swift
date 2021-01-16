//
//  WatchManager.swift
//  Contributions
//
//  Created by fincher on 1/10/21.
//

import Foundation
import ClockKit
import WatchConnectivity

class WatchManager : RuntimeManagableSingleton, WCSessionDelegate
{
    static let shared: WatchManager = {
        let instance = WatchManager()
        return instance
    }()
    
    override private init() { }
    
    override class func setup() {
        print("WatchManager.setup")
        WatchManager.shared.initSession()
    }
    
    //MARK: WCSessionDelegate
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WatchManager.sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WatchManager.sessionDidDeactivate")
        WCSession.default.activate()
    }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WatchManager.sessionActivationDidCompleteWith \(activationState.rawValue) error \(String(describing: error))")
        refresh()
        #if os(iOS)
        
        #elseif os(watchOS)
        
        #endif
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:])
    {
        print("WatchManager.didReceiveUserInfo")
        #if os(iOS)
        // do nothing
        #elseif os(watchOS)
        // handle info from iOS
        DispatchQueue.main.async {
            PreferenceManager.shared.importUserDefaultDict(dict: userInfo)
            ComplicationManager.shared.reload()
        }
        #endif
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any])
    {
        print("WatchManager.didReceiveApplicationContext")
        #if os(iOS)
        // do nothing
        #elseif os(watchOS)
        // handle info from iOS
        DispatchQueue.main.async {
            PreferenceManager.shared.importUserDefaultDict(dict: applicationContext)
            ComplicationManager.shared.reload()
        }
        #endif
    }
    
    func refresh() -> Void {
        print("WatchManager.refresh")
        #if os(iOS)
        // send userDefaults to watch
        if WCSession.default.activationState == .activated && WCSession.default.isWatchAppInstalled {
            let dict = PreferenceManager.shared.exportUserDefaultDict()
//            print("WCSession.default.transferUserInfo \(dict)")
//            WCSession.default.transferUserInfo(dict) // non-override
            do {
//                print("WCSession.default.updateApplicationContext \(dict)")
                try WCSession.default.updateApplicationContext(dict) // override
            } catch {
                print("WCSession.default.updateApplicationContext error: \(error).")
            }
        }
        #elseif os(watchOS)
        // do nothing, maybe
        
        #endif
    }
    
    func initSession() -> Void
    {
        #if os(iOS)
        print("WCSession.isSupported() \(WCSession.isSupported()) isPaired() \(WCSession.default.isPaired) isWatchAppInstalled \(WCSession.default.isWatchAppInstalled)")
        #elseif os(watchOS)
        print("WCSession.isSupported() \(WCSession.isSupported())")
        #endif
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            refresh()
        }
    }
}
