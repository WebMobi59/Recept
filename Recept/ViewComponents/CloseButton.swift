//
//  CloseButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-19.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

open class CloseButton: UIButton {
    var lastControlState: UIControlState!
    
    fileprivate let svgImage: SVGKFastImageView!
    fileprivate let backgroundCircle: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let svgImage = SVGKFastImageView(frame: frame)
        svgImage.image = SVGKImage(named: "close_circle.svg")
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
    
    fileprivate func transformToHighlighted() {
        self.backgroundCircle.backgroundColor = AppoteketTheme.Colors.DrawerBackgroundHighlighted
    }
    
    fileprivate func transformToNormal() {
        self.backgroundCircle.backgroundColor = UIColor.clear
    }
}
