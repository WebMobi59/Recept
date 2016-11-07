//
//  ArrowButtonLeft.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class ArrowButtonLeft: ArrowButtonRight
{
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.rotate180()
    }
    
    fileprivate func rotate180() {
        self.transform = CGAffineTransform(rotationAngle: AngleUtility.DegreesToRadians(180))
    }
}
