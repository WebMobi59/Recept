//
//  ApoteketButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class GreenButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = AppoteketTheme.Colors.DefaultAction
        self.layer.cornerRadius = AppoteketTheme.Dimension.ButtonBorderRadius(self.frame.height)
        self.setTitleColor(AppoteketTheme.Colors.DefaultActionText, for: UIControlState())
        self.setTitleColor(AppoteketTheme.Colors.DefaultActionTextActive, for: .highlighted)
        self.titleLabel?.font = AppoteketTheme.Fonts.Button
        self.adjustsImageWhenHighlighted = false
        self.adjustsImageWhenDisabled = false
        self.showsTouchWhenHighlighted = false
    }
    
    open var title: String? {
        get {
            return self.title(for: UIControlState())
        }
        set {
            self.setTitle(newValue, for: UIControlState())
        }
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            let backgroundColor = newValue ? AppoteketTheme.Colors.DefaultActionActive : AppoteketTheme.Colors.DefaultAction
            
            AnimationUtility.animate(AppoteketTheme.Animation.ShortDuration, options: AppoteketTheme.Animation.ShortOptions) {
                self.backgroundColor = backgroundColor
            }
        }
    }
}
