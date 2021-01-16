//
//  UIScreen+Wallpaper.swift
//  Mapaper
//
//  Created by fincher on 12/29/20.
//

import Foundation
import UIKit

extension UIScreen
{
    // must < max pixel length / 2 and < 1280 (mapbox)
    var walllpaperMaxSize: Int {
        let bounds = self.nativeBounds
        let side : CGFloat = min(1280.0, max (bounds.height, bounds.width) / 2.0)
        let finalSize = Int(floor(side))
        return finalSize > 0 ? finalSize : 1024
    }
}
