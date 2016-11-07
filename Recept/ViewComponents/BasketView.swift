//
//  BasketView.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-10.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class BasketView: UIButton {
    var lastControlState: UIControlState!
    var basketButton: BasketButton!
    var topLabel: DefaultLabel!
    var bottomLabel: DefaultLabel!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.basketButton = BasketButton()
        self.basketButton.isUserInteractionEnabled = false // Let the complete view take all user interaction
        self.addSubview(self.basketButton)
        Restraint(self.basketButton, .width, .equal, 40).addToView(self)
        Restraint(self.basketButton, .height, .equal, 40).addToView(self)
        Restraint(self.basketButton, .trailing, .equal, self, .trailing, 1, 0).addToView(self)
        Restraint(self.basketButton, .top, .equal, self, .top, 1, 0).addToView(self)
        
        self.topLabel = DefaultLabel()
        self.topLabel.textAlignment = .right
        self.topLabel.font = AppoteketTheme.Fonts.BasketTop
        self.topLabel.textColor = AppoteketTheme.Colors.PrimaryAction
        self.addSubview(self.topLabel)
        Restraint(self.topLabel, .width, .greaterThanOrEqual, 0).addToView(self)
        Restraint(self, .leading, .equal, self.topLabel, .leading, 1 , 0).addToView(self)
        Restraint(self.basketButton, .leading, .equal, self.topLabel, .trailing, 1 , 4).addToView(self)
        Restraint(self.topLabel, .bottom, .equal, self, .centerY, 1 , 2).addToView(self)
        
        self.bottomLabel = DefaultLabel()
        self.bottomLabel.textAlignment = .right
        self.bottomLabel.font = AppoteketTheme.Fonts.BasketBottom
        self.bottomLabel.textColor = AppoteketTheme.Colors.PrimaryAction
        self.addSubview(self.bottomLabel)
        Restraint(self.bottomLabel, .width, .greaterThanOrEqual, 0).addToView(self)
        Restraint(self, .leading, .equal, self.bottomLabel, .leading, 1 , 0).addToView(self)
        Restraint(self.basketButton, .leading, .equal, self.bottomLabel, .trailing, 1 , 4).addToView(self)
        Restraint(self.bottomLabel, .top, .equal, self, .centerY, 1 , 2).addToView(self)
        
        self.setTitle(nil, for: UIControlState())
        lastControlState = self.state
        
        self.setBasketValues(nil, topText: nil, bottomText: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if lastControlState != self.state {
            switch self.state {
            case UIControlState.highlighted:
                self.transformToHighlighted()
                break
            default:
                self.transformToNormal()
                break
            }
            self.lastControlState = self.state
        }
    }
    
    override open var isHidden: Bool {
        get { return super.isHidden }
        set {
            super.isHidden = newValue
            self.transform = newValue ? CGAffineTransform(scaleX: 0.01, y: 0.01) : CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    open func hidden(_ newValue: Bool, transformed: Bool) {
        self.hidden(newValue, transformed: transformed, completion: nil)
    }
    
    fileprivate func hidden(_ newValue: Bool, transformed: Bool, completion: (() -> Void)?) {
        if !transformed {
            self.isHidden = newValue
            return
        }
        
        if newValue != self.isHidden {
            self.topLabel.layer.removeAllAnimations()
            self.bottomLabel.layer.removeAllAnimations()
            if newValue {
                AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration,
                    animations: {
                        self.alpha = 0
                    },
                    completion: { (_) -> Void in
                        super.isHidden = newValue
                        self.alpha = 1
                        completion?()
                    }
                )
            }
            else {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                super.isHidden = newValue
                AnimationUtility.animateBouncing(0.8, damping: 0.5) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
    }
    
    open func hideAndResetAnimated() {
        self.hidden(true, transformed: true) {
            self.setBasketValues(nil, topText: nil, bottomText: nil)
        }
    }
    
    open func setBasketValues(_ badge: NSInteger?, topText: String?, bottomText: String?) {
        self.setBadge(badge)
        self.setTopText(topText)
        self.setBottomText(bottomText)
    }
    
    open func bounce() {
        if self.isHidden {
            return
        }
        
        AnimationUtility.animate(0.15, animations:
            {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: {
                (_) in
                AnimationUtility.animateBouncing(0.8, damping: 0.5) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        )
    }
    
    open var badge: NSInteger? {
        get { return self.basketButton.badge }
    }
    fileprivate func setBadge(_ newValue: NSInteger?) {
        self.basketButton.badge = newValue
    }
    
    open var topText: String? {
        get { return self.topLabel.text }
    }
    fileprivate func setTopText(_ newValue: String?) {
        self.topLabel.text = newValue
    }
    
    open var bottomText: String? {
        get { return self.bottomLabel.text }
    }
    fileprivate func setBottomText(_ newValue: String?) {
        self.bottomLabel.text = newValue
    }
    
    fileprivate func transformToHighlighted() {
        self.basketButton.transformToHighlighted()
        
        // Text color cannot be animated by default, so this is a hack for that corresponding to tranform time of basket circle
        UIView.transition(with: self.topLabel, duration: 0.15, options: .transitionCrossDissolve,
            animations:
            {
                self.topLabel.textColor = AppoteketTheme.Colors.PrimaryActionActive
            }, completion: nil
        )
        
        UIView.transition(with: self.bottomLabel, duration: 0.15, options: .transitionCrossDissolve,
            animations:
            {
                self.bottomLabel.textColor = AppoteketTheme.Colors.PrimaryActionActive
            }, completion: nil
        )
    }
    
    fileprivate func transformToNormal() {
        self.basketButton.transformToNormal()
        
        // Text color cannot be animated by default, so this is a hack for that
        UIView.transition(with: self.topLabel, duration: 0.15, options: .transitionCrossDissolve,
            animations:
            {
                self.topLabel.textColor = AppoteketTheme.Colors.PrimaryAction
            }, completion: nil
        )
        
        UIView.transition(with: self.bottomLabel, duration: 0.15, options: .transitionCrossDissolve,
            animations:
            {
                self.bottomLabel.textColor = AppoteketTheme.Colors.PrimaryAction
            }, completion: nil
        )
    }
}
