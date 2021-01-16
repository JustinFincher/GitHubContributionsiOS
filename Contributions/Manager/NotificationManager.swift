//
//  NotificationManager.swift
//  Dynamic
//
//  Created by fincher on 12/14/20.
//

import UserNotifications
import Foundation

class NotificationManager : RuntimeManagableSingleton, UNUserNotificationCenterDelegate {
    
    static let shared: NotificationManager = {
        let instance = NotificationManager()
        return instance
    }()
    
    override private init() { }
    
    override class func setup() {
        print("NotificationManager.setup")
        NotificationManager.shared.refresh()
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
            self.refresh()
        }
    }
    
    func sendNoficiation(title: String, subtitle: String, body: String, attachment: [UNNotificationAttachment]) -> Void {
        if EnvironmentManager.shared.env.notificationPermissionGranted {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.body = body
            content.attachments = attachment
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("\(error)")
                }
            }
        }
    }
    
    func refresh() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    EnvironmentManager.shared.env.notificationPermissionGranted = true; break
                case .denied:
                    EnvironmentManager.shared.env.notificationPermissionGranted = false; break
                case .notDetermined:
                    EnvironmentManager.shared.env.notificationPermissionGranted = false; break
                case .provisional:
                    EnvironmentManager.shared.env.notificationPermissionGranted = true; break
                case .ephemeral:
                    EnvironmentManager.shared.env.notificationPermissionGranted = true; break
                @unknown default:
                    EnvironmentManager.shared.env.notificationPermissionGranted = false; break
                }
            }
        }
    }
}
