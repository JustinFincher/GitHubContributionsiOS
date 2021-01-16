//
//  UIView+Screenshot.swift
//  Contributions
//
//  Created by fincher on 1/9/21.
//

import UIKit

extension UIView
{
    func asImage(async: Bool = false) -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
    // [!!] Uncomment to clip resulting image
    //             rendererContext.cgContext.addPath(
    //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
    //            rendererContext.cgContext.clip()

    // As commented by @MaxIsom below in some cases might be needed
    // to make this asynchronously, so uncomment below DispatchQueue
    // if you'd same met crash
                    if async {
                        DispatchQueue.main.async {
                            self.layer.render(in: rendererContext.cgContext)
                        }
                    } else {
                        layer.render(in: rendererContext.cgContext)
                    }
                }
            }
    
//
//    func takeScreenshot() -> UIImage {
//            // Begin context
//            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
//            // Draw view in that context
//            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//            // And finally, get image
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            if (image != nil) {
//                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
//                return image!
//            }
//
//            return UIImage()
//    }
    
    var renderedImage: UIImage {
            // rect of capure
            let rect = self.bounds
            // create the context of bitmap
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            self.layer.render(in: context)
            // get a image from current context bitmap
            let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return capturedImage
        }
}
