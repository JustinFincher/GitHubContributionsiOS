//
//  View+Screenshot.swift
//  Contributions
//
//  Created by fincher on 1/11/21.
//

import Foundation
import SwiftUI

extension View {
    func asImage(async: Bool = false) -> UIImage {
            let controller = UIHostingController(rootView: self)

            // locate far out of screen
            controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
            UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

            let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.sizeToFit()

            let image = controller.view.asImage(async: async)
            controller.view.removeFromSuperview()
            return image
        }
    
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
            let window = UIWindow(frame: CGRect(origin: origin, size: size))
            let hosting = UIHostingController(rootView: self)
            hosting.view.frame = window.frame
            window.addSubview(hosting.view)
            window.makeKeyAndVisible()
            return hosting.view.renderedImage
        }
}
