//
//  ArrowButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class ArrowButtonRight: UIButton
{
    var lastControlState: UIControlState!
    
    fileprivate let svgImage: SVGKFastImageView!
    fileprivate let backgroundCircle: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let svgImage = SVGKFastImageView(frame: frame)
        svgImage.image = SVGKImage(named: "arrow_right.svg")
        svgImage.layer.allowsEdgeAntialiasing = true
        self.svgImage = svgImage
        
        let backgroundCircle = UIView(frame: frame)
        backgroundCircle.backgroundColor = UIColor.clear
        backgroundCircle.layer.cornerRadius = frame.width / 2
        self.backgroundCircle = backgroundCircle
        
        super.init(coder: aDecoder)
        self.addSubview(backgroundCircle)
        self.addSubview(svgImage)
        
        self.setTitle("", for: UIControlState())
        self.layer.cornerRadius = self.frame.width / 2
        self.svgImage.isUserInteractionEnabled = false
        self.backgroundCircle.isUserInteractionEnabled = false
        lastControlState = self.state
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if lastControlState != self.state {
            switch self.state {
            case UIControlState.disabled:
                self.transformToDisabled()
                break
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
    
    fileprivate func transformToDisabled() {
        self.backgroundCircle.backgroundColor = UIColor.clear
        self.alpha = 0.25
        self.isUserInteractionEnabled = false
    }
    
    fileprivate func transformToHighlighted() {
        self.backgroundCircle.backgroundColor = AppoteketTheme.Colors.DrawerBackgroundHighlighted
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    fileprivate func transformToNormal() {
        self.backgroundCircle.backgroundColor = UIColor.clear
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    
}
