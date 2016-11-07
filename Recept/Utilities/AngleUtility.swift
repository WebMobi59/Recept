//
//  Angle.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-06.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class AngleUtility {
    static open func DegreesToRadians(_ value:CGFloat) -> CGFloat {
        return value * CGFloat(M_PI) / 180.0
    }

    static open func RadiansToDegrees(_ value:CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(M_PI)
    }
}
