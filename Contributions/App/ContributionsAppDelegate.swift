//
//  ContributionsAppDelegate.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import Foundation
import Intents
import UIKit
import Kingfisher
import BackgroundTasks

class ContributionsAppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Kingfisher.ImageCache.default.memoryStorage.config.totalCostLimit = 30 * 1024 * 1024
        Kingfisher.ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
        
        RuntimeManager.shared.spawn()
    
        BGTaskScheduler.shared.register(forTaskWithIdentifier: ContributionsAppInfo.backgroundTaskId, using: DispatchQueue.global(qos: .background)) { task in
            self.handleTask(task: task as! BGAppRefreshTask)
        }
        return true
    }
    
    func handleTask(task : BGAppRefreshTask) -> Void {
        print("Handle Task \(task.identifier)")
        if task.identifier != ContributionsAppInfo.backgroundTaskId {
            return
        }
        task.expirationHandler = {
            print("Handle Task \(task.identifier) Expired")
            self.scheduleTask()
            task.setTaskCompleted(success: false)
        }
        ContributionsManager.shared.backgroundFetchAll {
            print("Handle Task \(task.identifier) Success")
            DispatchQueue.main.async {
                EnvironmentManager.shared.env.backgroundFetchTriggeredDate = Date()
            }
            self.scheduleTask()
            task.setTaskCompleted(success: true)
        }
    }
    
    func scheduleTask() -> Void {
        print("Cancel Task")
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: ContributionsAppInfo.backgroundTaskId)
        print("Schedule Task")
        let task = BGAppRefreshTaskRequest(identifier: ContributionsAppInfo.backgroundTaskId)
        task.earliestBeginDate = Date(timeIntervalSinceNow: 900)
        do {
            try BGTaskScheduler.shared.submit(task)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
            print("\(error)")
        }
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            requests.forEach { request in
                print("getPendingTaskRequests \(String(describing: request.identifier)) \(String(describing: request.earliestBeginDate))")
            }
        }
        
    }
    
    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        switch intent {
        case is Default2DConfigurationIntent:
            return Default2DConfigurationIntentHandler()
        case is TodayConfigurationIntent:
            return TodayConfigurationIntentHandler()
        default:
            return nil
        }
    }
}
