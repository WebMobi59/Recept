//
//  DrawerButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-06.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class DrawerButton: UIButton {
    var lastControlState: UIControlState!
    
    fileprivate let drawerCircle: UIView!
    fileprivate let topLine: UIView!
    fileprivate let middleLine: UIView!
    fileprivate let bottomLine: UIView!
    
    fileprivate let lineSpacing: CGFloat = 5.5
    fileprivate let lineCornerRadius: CGFloat = 1
    fileprivate let maxTopRotation: CGFloat = AngleUtility.DegreesToRadians(-45)
    fileprivate let maxBottomRotation: CGFloat = AngleUtility.DegreesToRadians(45)
    fileprivate let maxMiddleAlphaTransform: Float = 0

    required public init?(coder aDecoder: NSCoder) {
        let drawerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        drawerCircle.backgroundColor = UIColor.white
        drawerCircle.layer.borderColor = AppoteketTheme.Colors.Drawer.cgColor
        drawerCircle.layer.borderWidth = 1
        drawerCircle.layer.cornerRadius = drawerCircle.bounds.height / 2
        drawerCircle.layer.allowsEdgeAntialiasing = true
        
        let lineXOffset: CGFloat = 9
        let lineHeight: CGFloat = 3
        let lineWidth: CGFloat = drawerCircle.bounds.width - (2 * lineXOffset)
        
        let midY: CGFloat = drawerCircle.bounds.height / 2
        
        let topLine = UIView(frame: CGRect(x: lineXOffset, y: midY - self.lineSpacing - (lineHeight / 2), width: lineWidth, height: lineHeight))
        topLine.layer.cornerRadius = self.lineCornerRadius
        topLine.layer.allowsEdgeAntialiasing = true
        let middleLine = UIView(frame: CGRect(x: lineXOffset, y: midY - (lineHeight / 2), width: lineWidth, height: lineHeight))
        middleLine.layer.cornerRadius = self.lineCornerRadius
        middleLine.layer.allowsEdgeAntialiasing = true
        let bottomLine = UIView(frame: CGRect(x: lineXOffset, y: midY + self.lineSpacing - (lineHeight / 2), width: lineWidth, height: lineHeight))
        bottomLine.layer.cornerRadius = self.lineCornerRadius
        bottomLine.layer.allowsEdgeAntialiasing = true
        
        topLine.backgroundColor = AppoteketTheme.Colors.Drawer
        middleLine.backgroundColor = AppoteketTheme.Colors.Drawer
        bottomLine.backgroundColor = AppoteketTheme.Colors.Drawer
        
        drawerCircle.addSubview(topLine)
        drawerCircle.addSubview(middleLine)
        drawerCircle.addSubview(bottomLine)
        
        self.drawerCircle = drawerCircle
        self.topLine = topLine
        self.middleLine = middleLine
        self.bottomLine = bottomLine
        
        super.init(coder: aDecoder)
        self.addSubview(drawerCircle)
        
        self.setTitle("", for: UIControlState())
        self.drawerCircle.isUserInteractionEnabled = false
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
    
    open func updateVisualState(_ drawerOpenPercent: CGFloat) {
        // Top adjustment
        var topLineTransform: CATransform3D = CATransform3DIdentity
        topLineTransform = CATransform3DTranslate(topLineTransform, 0, self.lineSpacing * drawerOpenPercent, 0)
        topLineTransform = CATransform3DRotate(topLineTransform, maxTopRotation * drawerOpenPercent, 0, 0, 1)
        self.topLine.layer.transform = topLineTransform
        self.topLine.layer.cornerRadius = self.lineCornerRadius * (1 - drawerOpenPercent)
        
        // Bottom
        var bottomLineTransform: CATransform3D = CATransform3DIdentity
        bottomLineTransform = CATransform3DTranslate(bottomLineTransform, 0, (-self.lineSpacing) * drawerOpenPercent, 0)
        bottomLineTransform = CATransform3DRotate(bottomLineTransform, maxBottomRotation * drawerOpenPercent, 0, 0, 1)
        //self.bottomLine.alpha = 0
        self.bottomLine.layer.transform = bottomLineTransform
        self.bottomLine.layer.cornerRadius = self.lineCornerRadius * (1 - drawerOpenPercent)
        
        // Middle
        let acceleratedOpenPercent = min(drawerOpenPercent * 2, 1)
        self.middleLine.layer.opacity = (1-maxMiddleAlphaTransform) * (1-Float(acceleratedOpenPercent))
    }
    
    fileprivate func transformToHighlighted() {
        self.drawerCircle.backgroundColor = AppoteketTheme.Colors.DrawerBackgroundHighlighted
    }
    
    fileprivate func transformToNormal() {
        self.drawerCircle.backgroundColor = AppoteketTheme.Colors.DrawerBackground
    }
}
