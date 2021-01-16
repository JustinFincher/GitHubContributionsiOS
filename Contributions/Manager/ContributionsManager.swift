//
//  ContributionsManager.swift
//  Contributions
//
//  Created by fincher on 1/8/21.
//

import Foundation
import Kanna
import UserNotifications
import SwiftUI

class ContributionsManager: RuntimeManagableSingleton
{
    static let shared: ContributionsManager = {
        let instance = ContributionsManager()
        return instance
    }()
    
    override class func setup() {
        print("ContributionsManager.setup")
    }
    
    private override init() {
        super.init()
    }
    
    func getUrl(userName: String) -> URL? {
        let u = userName.gitHubComplaintUserName()
        if !u.isEmpty {
            return URL.init(string: "https://github.com/users/\(u)/contributions")
        } else {
            return nil
        }
    }
    
    func update(userName : String, autoUpdateEnv : Bool = true, completion: @escaping (Bool, Contributions?) -> ()) -> Void {
        let u = userName.gitHubComplaintUserName()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        var contributions : Contributions = Contributions(list: [], updated: Date())
        if let url = self.getUrl(userName: u)
        {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let data = data,
                   let doc : XMLDocument = try? Kanna.HTML(html: String(decoding: data, as: UTF8.self), encoding: .utf8),
                   let svg = doc.css("svg").first(where: { ele -> Bool in
                     ele["class"] == "js-calendar-graph-svg"
                   })
                {
//                    print(String(data: data, encoding: .utf8)!)
                    for rect in svg.css("rect") {
                        if rect["class"] == "day",
                           let rawDate : String = rect["data-date"],
                           let date : Date = dateFormatter.date(from: rawDate),
                           let rawCount : String = rect["data-count"],
                           let count : Int = Int.init(rawCount)
                        {
                            let contribution = Contribution(date: date, dateRawString: rawDate, count: count, fillRawString: "")
                            contributions.list.append(contribution)
                        }
                    }
                    completion(true, contributions)
                    DispatchQueue.main.async {
                        if autoUpdateEnv {
                            EnvironmentManager.shared.env.userContributions.dict[u] = contributions
                        }
                    }
                } else {
                    completion(false, nil)
                    return
                }
            }
            task.resume()
            DispatchQueue.main.async {
                if !EnvironmentManager.shared.env.userNames.contains(u)
                {
                    EnvironmentManager.shared.env.userNames.append(u)
                }
                self.cleanUnusedUsers()
            }
        } else {
            completion(false, nil)
            return
        }
    }
    
    func backgroundFetchAll(completion: @escaping () -> ()) -> Void {
        updateAll(autoUpdateEnv: false) { userContributions in
            if EnvironmentManager.shared.env.postBackgroundRefreshNotification
            {
                let selectedUser = EnvironmentManager.shared.env.selectedUserName
                if let contributions = userContributions.contributionsFor(name: selectedUser) {
                    self.scheduleNotification(user: selectedUser, contributions: contributions)
                }
            }
            completion()
        }
    }
    
    func scheduleNotification(user: String, contributions: Contributions) -> Void {
        var attachment : [UNNotificationAttachment] = []
        let body : String =
            String(format: NSLocalizedString("title_%@_has_%d_commits_in_%d_days", comment: ""), user, contributions.commitsCount, contributions.dayCount)
//            String.localizedStringWithFormat("title_%@_has_%d_commits_in_%d_days", user, contributions.commitsCount, contributions.dayCount)
        let image = ProfilePosterView(
            userName: Binding<String>(get: { return user }, set: { _ in }),
            contributions: Binding<Contributions>(get: { return contributions }, set: { _ in })
        ).takeScreenshot(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 500, height: 370))
        if let documentsURL = StorageManager.shared.appGroupDocumentsURL,
           let jpeg = image.jpegData(compressionQuality: 100)
        {
            let imageURL = documentsURL.appendingPathComponent("notification.jpeg")
            do {
                if !StorageManager.shared.fileManager.fileExists(atPath: imageURL.path) {
                    try StorageManager.shared.fileManager.createDirectory(at: imageURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: [:])
                }
                try jpeg.write(to: imageURL)
                let attach = try UNNotificationAttachment(identifier: "", url: imageURL, options: [:])
                attachment.append(attach)
            } catch let err {
                print(err)
            }
        } else {
            print("appGroupDocumentsURL \(String(describing: StorageManager.shared.appGroupDocumentsURL))")
        }
        NotificationManager.shared.sendNoficiation(title: "", subtitle: "", body: body, attachment: attachment)
    }
    
    func updateAll(autoUpdateEnv: Bool = true, completion: @escaping (UserContributions) -> ()) -> Void {
        var dict : [String : Contributions] = [:]
        let dispatchGroup = DispatchGroup()
        EnvironmentManager.shared.env.userNames.forEach { u in
            dispatchGroup.enter()
            print("updating \(u)")
            update(userName: u, autoUpdateEnv: false) { (success, contributions) in
                print("updated \(u) success \(success)")
                if let contributions = contributions {
                    dict[u] = contributions
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("updateAll finished")
            let userConributions = UserContributions(dict: dict)
            if autoUpdateEnv {
                EnvironmentManager.shared.env.userContributions = userConributions
                EnvironmentManager.shared.env.backgroundFetchTriggeredDate = Date()
            }
            completion(userConributions)
        }
    }
    
    func cleanUnusedUsers() -> Void {
        EnvironmentManager.shared.env.userContributions.dict.keys.forEach { key in
            if !EnvironmentManager.shared.env.userNames.contains(key)
            {
                EnvironmentManager.shared.env.userContributions.dict.removeValue(forKey: key)
            }
        }
    }
}
