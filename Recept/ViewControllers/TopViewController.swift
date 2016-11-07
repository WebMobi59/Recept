//
//  TopViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol TopViewDelegate: class {
    func didTapDrawer()
    func didTapBasket()
    func didTapLogo()
}

open class TopViewController: UIViewController, ApplicationTopViewDelegate {
    weak var delegate: TopViewDelegate?
    fileprivate var analyticsService: AnalyticsService!
    
    @IBOutlet weak var drawerToggleButton: DrawerButton!
    @IBOutlet weak var basketButton: BasketView!
    @IBOutlet weak var topSeparatorLine: UIView!
    @IBOutlet weak var logoButton: LogoButton!
    
    required public init(analyticsService: AnalyticsService!) {
        super.init(nibName: "Top", bundle: nil)
        self.analyticsService = analyticsService
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        self.basketButton.isHidden = true
        self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: UIScreen.main.bounds.width, height: self.view.frame.height))
        self.topSeparatorLine.backgroundColor = AppoteketTheme.Colors.TopSeparator
    }
    
    @IBAction func drawerTap(_ sender: UIButton) {
        self.delegate?.didTapDrawer()
    }
    
    @IBAction func basketTap(_ sender: UIButton) {
        self.delegate?.didTapBasket()
    }
    
    @IBAction func logoTap(_ sender: UIButton) {
        self.delegate?.didTapLogo()
    }
    
    open func setBasketValues(_ badge: NSInteger?, topText: String?, bottomText: String?) {
        if badge != nil {
            self.showOrBounceBasketButton(badge, topText: topText, bottomText: bottomText)
        }
        else {
            basketButton.hideAndResetAnimated()
        }
    }
    
    fileprivate func showOrBounceBasketButton(_ badge: NSInteger?, topText: String?, bottomText: String?) {
        let previousBadge = basketButton.badge
        basketButton.setBasketValues(badge, topText: topText, bottomText: bottomText)
        if basketButton.isHidden {
            basketButton.hidden(false, transformed: true)
        }
        else {
            if previousBadge != badge {
                basketButton.bounce()
            }
        }
    }
    
    open func menuOpenPercentChanged(_ openPercent: CGFloat) {
        self.drawerToggleButton.updateVisualState(openPercent)
    }
}
