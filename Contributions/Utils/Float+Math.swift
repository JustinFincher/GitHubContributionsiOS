//
//  Float+Math.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import Foundation

extension Float {
    
    func lerpClamped(from : Float, to: Float) -> Float {
        (to - from) * self.clamped(to: 0...1) + from
    }
    
    func lerp(from : Float, to: Float) -> Float {
        (to - from) * self + from
    }
}
