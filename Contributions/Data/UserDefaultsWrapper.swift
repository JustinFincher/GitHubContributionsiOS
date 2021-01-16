//
//  UserDefaultWrapper.swift
//  Dynamic
//
//  Created by Fincher on 12/10/20.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var postSetHandler : ((T,T) -> Void)?

    var wrappedValue: T {
        get {
            PreferenceManager.shared.userDefault.value(forKey: key) as? T ?? defaultValue
        } set {
            if let postSetHandler = postSetHandler {
                let old = wrappedValue
                PreferenceManager.shared.userDefault.set(newValue, forKey: key)
                postSetHandler(old, newValue)
            } else {
                PreferenceManager.shared.userDefault.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct CodableUserDefault<T : Codable> {
    let key: String
    let defaultValue: T
    var postSetHandler : ((T,T) -> Void)?

    var wrappedValue: T {
        get {
            let decoder = JSONDecoder()
            if let value = PreferenceManager.shared.userDefault.value(forKey: key) as? Data,
               let decoded = try? decoder.decode(T.self, from: value)
            {
                return decoded
            }
            return defaultValue
        } set {
            let encoder = JSONEncoder()
            if let postSetHandler = postSetHandler {
                let old = wrappedValue
                if let encoded = try? encoder.encode(newValue) {
                    PreferenceManager.shared.userDefault.set(encoded, forKey: key)
                }
                postSetHandler(old, newValue)
            } else {
                if let encoded = try? encoder.encode(newValue) {
                    PreferenceManager.shared.userDefault.set(encoded, forKey: key)
                }
            }
        }
    }
}
