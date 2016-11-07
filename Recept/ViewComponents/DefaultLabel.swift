//
//  DefaultLabel.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class DefaultLabel: UILabel {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    required public init() {
        super.init(frame: CGRect())
        self.setup()
    }
    
    fileprivate func setup() {
        self.font = AppoteketTheme.Fonts.Default
        self.textColor = AppoteketTheme.Colors.DefaultText
    }
}
