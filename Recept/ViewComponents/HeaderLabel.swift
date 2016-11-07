//
//  DefaultLabel.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class HeaderLabel: UILabel {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = AppoteketTheme.Fonts.Header
        self.textColor = AppoteketTheme.Colors.HeaderText
    }
}
