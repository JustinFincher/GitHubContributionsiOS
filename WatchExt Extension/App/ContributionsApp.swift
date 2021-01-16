//
//  ContributionsApp.swift
//  WatchExt Extension
//
//  Created by fincher on 1/9/21.
//

import SwiftUI

@main
struct ContributionsApp: App {
    
    @WKExtensionDelegateAdaptor(ContributionsAppDelegate.self) var appDelegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                AppView()
                    .environmentObject(EnvironmentManager.shared.env)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
