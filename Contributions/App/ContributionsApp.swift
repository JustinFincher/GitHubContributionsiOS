//
//  ContributionsSwiftUIApp.swift
//  ContributionsSwiftUI
//
//  Created by fincher on 10/19/20.
//

import SwiftUI
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
}

@main
struct ContributionsApp: App {
    
    @Environment(\.openURL) var openURL
    @UIApplicationDelegateAdaptor(ContributionsAppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase : ScenePhase
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(EnvironmentManager.shared.env)
                .onOpenURL(perform: { url in
                    print("onOpenURL \(url)")
                })
        }.onChange(of: scenePhase) { phase in
            print("ContributionsApp go \(phase)")
            switch phase {
                case .active:
                    if EnvironmentManager.shared.env.backgroundFetchTriggeredDate.timeIntervalSinceNow < -1200 {
                        EnvironmentManager.shared.env.showView(view: AnyView(ToastView(image: "arrow.triangle.2.circlepath", title: "title_updating")), forTime: .seconds(3))
                        ContributionsManager.shared.updateAll { _ in 
                        }
                    }
                    break
                case .background:
                    appDelegate.scheduleTask()
                    break
                case .inactive: break
                @unknown default: break
            }
        }
    }
}
