//
//  ReviewManager.swift
//  Mapaper
//
//  Created by fincher on 12/27/20.
//

import Foundation

class ReviewManager : RuntimeManagableSingleton
{
    static let shared: ReviewManager = {
        let instance = ReviewManager()
        return instance
    }()
    
    private override init() {
        
    }
    
    override class func setup() {
        print("ReviewManager.setup")
    }
    
    func countUsage() -> Void {
        
    }
}
