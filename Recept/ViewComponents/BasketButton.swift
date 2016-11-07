//
//  DrawerButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-06.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class BasketButton: SVGButton {
    var lastControlState: UIControlState!
    var currentBadge: NSInteger?
    var badgeLabel: UILabel!
    
    required public init() {
        self.badgeLabel = UILabel()
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lastControlState = self.state
        
        let basketImage = SVGKImage(named: "basket_circle.svg")
        basketImage?.size = CGSize(width: 40, height: 40)
        self.svgImageView?.image = basketImage
        
        let badgeSize = CGSize(width: 18, height: 18)
        let badgeOrigin = CGPoint(x: self.frame.width - badgeSize.width + 1, y: 0)
        
        self.badgeLabel.frame = CGRect(origin: badgeOrigin, size: badgeSize)
        self.badgeLabel.backgroundColor = AppoteketTheme.Colors.PrimaryActionContrast
        self.badgeLabel.layer.cornerRadius = badgeSize.height / 2
        self.badgeLabel.textColor = UIColor.white
        self.badgeLabel.clipsToBounds = true
        self.badgeLabel.textAlignment = NSTextAlignment.center
        self.badgeLabel.font = AppoteketTheme.Fonts.Badge
        self.addSubview(self.badgeLabel)
        
        self.badge = nil
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
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
        if !transformed {
            self.isHidden = newValue
            return
        }
        
        if newValue != self.isHidden {
            if newValue {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    },
                    completion: { (_) -> Void in
                        super.isHidden = newValue
                    }
                )
            }
            else {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                super.isHidden = newValue
                AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
    }
    
    open var badge: NSInteger? {
        get { return self.currentBadge }
        set {
            self.currentBadge = newValue
            updateBadge()
        }
    }
    
    fileprivate func updateBadge() {
        if let currentBadge = self.currentBadge {
            self.badgeLabel.text = String(currentBadge)
            
            if currentBadge >= 10 {
                let margins: CGFloat = 8
                let badgeSize: CGFloat = self.badgeLabel.intrinsicContentSize.width + margins
                self.badgeLabel.frame = CGRect(origin: self.badgeLabel.frame.origin, size: CGSize(width: badgeSize, height: self.badgeLabel.frame.height))
            }
            else {
                let badgeSize: CGFloat = 18
                self.badgeLabel.frame = CGRect(origin: self.badgeLabel.frame.origin, size: CGSize(width: badgeSize, height: self.badgeLabel.frame.height))
            }
            self.badgeLabel.isHidden = false
        }
        else {
            self.badgeLabel.isHidden = true
        }
    }
    
    open func transformToHighlighted() {
        self.backgroundCircle.fillColor = AppoteketTheme.Colors.PrimaryActionActive.cgColor
    }
    
    open func transformToNormal() {
        self.backgroundCircle.fillColor = AppoteketTheme.Colors.PrimaryAction.cgColor
    }
    
    fileprivate var backgroundCircle: CAShapeLayer {
        return self.svgImageView!.image.caLayerTree.sublayers![0] as! CAShapeLayer
    }
}
