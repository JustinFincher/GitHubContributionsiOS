//
//  WatchComplications.swift
//  Watch Extension
//
//  Created by fincher on 11/2/20.
//

import Foundation
import ClockKit
import WatchKit

class ComplicationManager : RuntimeManagableSingleton
{
    static let shared: ComplicationManager = {
        let instance = ComplicationManager()
        return instance
    }()
    
    override private init() { }
    
    override class func setup() {
        print("ComplicationManager.setup")
        CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
    }
    
    func reload() -> Void {
        CLKComplicationServer.sharedInstance().activeComplications?.forEach({ (c) in
            CLKComplicationServer.sharedInstance().reloadTimeline(for: c)
        })
    }
    
    func extend() -> Void {
        CLKComplicationServer.sharedInstance().activeComplications?.forEach({ (c) in
            CLKComplicationServer.sharedInstance().extendTimeline(for: c)
        })
    }
    
    func registerRefresh() -> Void {
        if let nextDate = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 15, to: Date())
        {
            print("scheduleRefresh \(Date()) -> \(nextDate)")
            WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextDate, userInfo: nil)
            {
                (err : Error?) in
                if let error = err {
                            print("*** An background refresh error occurred: \(error.localizedDescription) ***")
                            return
                } else {
                    print("scheduled")
                }
            }
        } else {
            print("error when generating next date for refresh")
        }
    }
    
    func handleRefresh(task : WKRefreshBackgroundTask) -> Void {
        switch task {
        case let backgroundTask as WKApplicationRefreshBackgroundTask:
            print("handleRefresh backgroundTask \(backgroundTask)")
            reload()
            registerRefresh()
            backgroundTask.setTaskCompletedWithSnapshot(false)
            break
        case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
            print("handleRefresh urlSessionTask \(urlSessionTask)")
            urlSessionTask.setTaskCompletedWithSnapshot(false)
            break
        case let snapshotTask as WKSnapshotRefreshBackgroundTask:
            print("handleRefresh snapshotTask \(snapshotTask)")
            snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 15, to: Date()), userInfo: nil)
            break
        default:
            task.setTaskCompletedWithSnapshot(false)
            break
        }
    }
}
