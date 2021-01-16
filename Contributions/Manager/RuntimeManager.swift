//
//  RuntimeManager.swift
//  Dynamic
//
//  Created by fincher on 12/25/20.
//

import Foundation

public class RuntimeManager {
    
    static let shared: RuntimeManager = {
        let instance = RuntimeManager()
        return instance
    }()
    
    private init()
    {
    }
    
    func spawn() -> Void {
        // init all other singletons
        let list = RuntimeHelper.subclasses(of: RuntimeManagableSingleton.self)
        list.forEach { (pro) in
            pro.setup()
        }
    }
}

@objc public class RuntimeManagableSingleton : NSObject {
    class func setup() -> Void {}
}
