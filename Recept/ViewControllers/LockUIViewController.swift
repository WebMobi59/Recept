//
//  LockUIViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-26.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class LockUIViewController: UIViewController, ApplicationLockUIViewDelegate {
    fileprivate var analyticsService: AnalyticsService!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: LockUILabel!
    
    required public init(analyticsService: AnalyticsService!) {
        super.init(nibName: "LockUI", bundle: nil)
        self.analyticsService = analyticsService
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func addAsSubviewFor(_ view: UIView!) {
        self.view.frame = view.frame
        self.spinner.startAnimating()
        
        self.view.alpha = 0
        view.addSubview(self.view)
        AnimationUtility.animate {
            self.view.alpha = 1
        }
    }
    
    open func removeViewAnimating(_ animated: Bool, completion: ((Bool) -> Void)?) {
        if !animated {
            self.view.removeFromSuperview()
            completion?(true)
        }
        else {
            AnimationUtility.animate(AppoteketTheme.Animation.DefaultDuration,
                animations: {
                    self.view.alpha = 0
                },
                completion: { (done) -> Void in
                    self.view.removeFromSuperview()
                    self.spinner.stopAnimating()
                    completion?(done)
                }
            )
        }
    }
    
    open func setLockUITextAnimated(_ text: String?) {
        AnimationUtility.animate(AppoteketTheme.Animation.DefaultDuration / 2,
            animations: {
                self.label.alpha = 0
            },
            completion: { (_) -> Void in
                self.label.text = text
                AnimationUtility.animate(AppoteketTheme.Animation.DefaultDuration / 2) {
                    self.label.alpha = 1
                }
            }
        )
    }
    
    open var lockUIText: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }
}
