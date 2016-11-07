//
//  LogoButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-11-10.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class LogoButton: SVGButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImage()
    }

    required public init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    fileprivate func setupImage() {
        let logoImage = SVGKImage(named: "logo.svg")
        logoImage?.size = self.frame.size
        self.svgImageView?.image = logoImage
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            guard newValue != super.isHighlighted else {
                return
            }
            super.isHighlighted = newValue
            
            let scaleFactor: CGFloat = newValue ? 1.05 : 1.0
            let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            AnimationUtility.animateBouncing { () -> Void in
                self.transform = scale
            }
        }
    }
}
