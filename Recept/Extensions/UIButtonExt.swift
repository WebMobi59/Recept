//
//  UIButtonExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        let roundedImage = BackgroundColorUtility.roundedImageWithColor(self.frame, color: color)
        self.setBackgroundImage(roundedImage, for: forState)
    }
}
