//
//  UIImage+Wallpaper.swift
//  Mapaper
//
//  Created by fincher on 1/6/21.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit

extension UIImage {
    
    func blur(radius: Float) -> UIImage? {
        //  Create our blurred image
        let context = CIContext(options: nil)
        if let cgImage : CGImage = self.cgImage
        {
            let inputImage = CIImage(cgImage: cgImage)
            //  Setting up Gaussian Blur
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(radius, forKey: "inputRadius")
            let result = filter?.value(forKey: kCIOutputImageKey) as? CIImage

           /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
            *  up exactly to the bounds of our original image */

            let cgImage = context.createCGImage(result ?? CIImage(), from: inputImage.extent)
            let retVal = UIImage(cgImage: cgImage!)
            return retVal
        }
        return nil
    }
}
