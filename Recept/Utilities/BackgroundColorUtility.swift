//
//  BackgroundColorUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class BackgroundColorUtility {
    open static func roundedImageWithColor(_ frame: CGRect, color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        UIGraphicsBeginImageContext(rect.size)
        
        // Add rounded corners
        UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).addClip()
        
        // Fill with color
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        // Get image for background
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
}
