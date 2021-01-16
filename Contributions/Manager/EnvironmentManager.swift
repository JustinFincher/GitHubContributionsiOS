//
//  EnvironmentManager.swift
//  Dynamic
//
//  Created by Fincher on 12/8/20.
//

import CoreLocation
import Foundation
import UIKit
import SwiftUI
import Combine
#if !os(watchOS)
import WidgetKit
#endif

class Env: ObservableObject
{
    @Environment(\.colorScheme) var colorScheme
    @Published var selectedTabIndex : Int = 0
    
    @UserDefault(key: "useiCloudKeyValue", defaultValue: false)
    var useiCloudKeyValue : Bool
    
    var accentColor: Color { Color.accentColor }
    
    @UserDefault(key: "selectedUserName", defaultValue: "JustinFincher", postSetHandler: {(o,n) in
        print("selectedUserName changed \(o) -> \(n)")
        #if !os(watchOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        #if os(iOS)
        WatchManager.shared.refresh()
        #endif
    })
    var selectedUserName : String
    
    @UserDefault(key: "userNames", defaultValue: ["JustinFincher"], postSetHandler: {(o,n) in print("userNames changed")
        #if os(iOS)
        WatchManager.shared.refresh()
        #endif
    })
    
    var userNames: [String]
    @CodableUserDefault(key: "userContributions", defaultValue: UserContributions(dict: [:]), postSetHandler: {(o,n) in print("userContributions changed")
        #if !os(watchOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        #if os(iOS)
        WatchManager.shared.refresh()
        #endif
    })
    var userContributions : UserContributions
    
    @UserDefault(key: "backgroundFetchTriggeredDate", defaultValue: Date.init(timeIntervalSince1970: 0))
    var backgroundFetchTriggeredDate: Date
    
    
    @UserDefault(key: "postBackgroundRefreshNotification", defaultValue: false)
    var postBackgroundRefreshNotification: Bool
    
    @Published var notificationPermissionGranted : Bool = false
    var permissionsAllGranted : Bool
    {
        notificationPermissionGranted
    }

    
    @Published var showGlobalView : Bool = false
    @Published var globalView : AnyView = AnyView(Color.clear)
    
    func showView(view: AnyView, forTime: DispatchTimeInterval) -> Void {
        self.showGlobalView = true
        self.globalView = view
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + forTime) {
                self.showGlobalView = false
            }
        }
    }
    
    func showView(view: AnyView) -> Void {
        self.showGlobalView = true
        self.globalView = view
    }
    func removeView() -> Void {
        self.showGlobalView = false
    }
    
    
    @UserDefault(key: "currentVersion", defaultValue: "0.0.0")
    var currentVersion: String
    @UserDefault(key: "currentBuild", defaultValue: "0")
    var currentBuild: String
    @UserDefault(key: "currentFeatureMark", defaultValue: "0")
    var currentFeatureMark: String
    
    @Published var canUseIAP : Bool = true
    
    private var notificationSubscription: AnyCancellable?
    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { notif in
            self.objectWillChange.send()
        }
    }
}

class EnvironmentManager : RuntimeManagableSingleton
{
    static let shared: EnvironmentManager = {
        let instance = EnvironmentManager()
        return instance
    }()
    
    let env: Env = Env()
    
    private override init() {}
    
    override class func setup() {
        print("EnvironmentManager.setup")
    }
}
