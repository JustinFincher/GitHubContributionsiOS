//
//  UIColor+Lerp.swift
//  Contributions
//
//  Created by fincher on 1/10/21.
//

import Foundation
import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return (red, green, blue, alpha)
        }
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

            return (hue, saturation, brightness, alpha)
        }
    
    func interpolateHSBAColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor {
        let f = min(max(0, fraction), 1)
        let selfHsba = self.hsba
        let targetHsba = end.hsba

        let h: CGFloat = CGFloat(selfHsba.hue + (targetHsba.hue - selfHsba.hue) * f)
        let s: CGFloat = CGFloat(selfHsba.saturation + (targetHsba.saturation - selfHsba.saturation) * f)
        let b: CGFloat = CGFloat(selfHsba.brightness + (targetHsba.brightness - selfHsba.brightness) * f)
        let a: CGFloat = CGFloat(selfHsba.alpha + (targetHsba.alpha - selfHsba.alpha) * f)

        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func interpolateRGBAColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor {
        let f = min(max(0, fraction), 1)
        let selfRgba = self.rgba
        let targetRgba = end.rgba

        let r: CGFloat = CGFloat(selfRgba.red + (targetRgba.red - selfRgba.red) * f)
        let g: CGFloat = CGFloat(selfRgba.green + (targetRgba.green - selfRgba.green) * f)
        let b: CGFloat = CGFloat(selfRgba.blue + (targetRgba.blue - selfRgba.blue) * f)
        let a: CGFloat = CGFloat(selfRgba.alpha + (targetRgba.alpha - selfRgba.alpha) * f)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
