//
//  CGSizeExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-30.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension CGSize {
    func scaledForDevice() -> CGSize {
        let scaleFactor: CGFloat
        scaleFactor = UIScreen.main.nativeScale
        return CGSize(width: width * scaleFactor, height: height * scaleFactor)
    }
}
