//
//  LockUILabel.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-26.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class LockUILabel: UILabel {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = AppoteketTheme.Fonts.LockUI
        self.textColor = AppoteketTheme.Colors.LockUI
    }
}
