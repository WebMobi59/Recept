//
//  DrawerViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-25.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol DrawerVisualStateDelegate: class {
    func didUpdateDrawerVisualState(_ percentVisible: CGFloat)
}

open class DrawerViewController: MMDrawerController, DrawerVisualStateDelegate {
    fileprivate let menuSide = MMDrawerSide.right
    fileprivate var menuIsEnabledState: Bool = false
    
    weak var delegate: DrawerVisualStateDelegate?
    
    /**
    Dependency injected init function
    
    @param mainViewController Provides the main content area for the application
    @param menuViewController The menu to be used for the app navigation
    */
    public required dynamic init(mainViewController: UIViewController!, menuViewController: UIViewController!)
    {
        super.init(center: mainViewController, rightDrawerViewController: menuViewController)
    }
    
    override required dynamic public init!(center centerViewController: UIViewController!, rightDrawerViewController: UIViewController!) {
        super.init(center: centerViewController, rightDrawerViewController: rightDrawerViewController)
    }
    
    override required dynamic public init!(center centerViewController: UIViewController!, leftDrawerViewController: UIViewController!, rightDrawerViewController: UIViewController!) {
        super.init(center: centerViewController, leftDrawerViewController: leftDrawerViewController, rightDrawerViewController: rightDrawerViewController)
    }
    
    override required dynamic public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    fileprivate func setup() {
//        self.setDrawerVisualStateBlock(MMDrawerVisualState.parallaxVisualStateBlockWithParallaxFactorSwift(1, drawerVisualStateDelegate: self))
        self.centerHiddenInteractionMode = .full
        self.maximumRightDrawerWidth = self.view.frame.width
        self.showsShadow = false
        self.animationVelocity = 1300
    }
    
    /**
    Boolean that indicates/sets wether the menu can be opened or not from user interaction
    
    */
    open var menuIsEnabled: Bool {
        get {
            return menuIsEnabledState
        }
        set {
            // Set the gestures for open/close
            if (newValue) {
                self.openDrawerGestureModeMask = MMOpenDrawerGestureMode.bezelPanningCenterView
                self.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningDrawerView
            }
            else {
                self.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
                self.closeDrawerGestureModeMask = MMCloseDrawerGestureMode()
            }
            menuIsEnabledState = newValue
        }
    }
    
    /**
    Toggles the menu between open and closed
    
    @param animated Determines whether the menu should be open animated.
    
    */
    open func toggleMenu(_ animated: Bool) {
        self.toggleMenu(animated) {_ in}
    }
    
    /**
    Toggles the menu between open and closed
    
    @param animated Determines whether the menu should be open animated.
    @param completion The block that is called when the toggle is open.
    */
    open func toggleMenu(_ animated: Bool, completion: ((Bool) -> Void)!) {
        if !self.menuIsEnabled {
            completion(false)
            return
        }
        self.toggle(menuSide, animated: animated, completion: completion)
    }
    
    /**
    Opens the menu
    
    @param animated Determines whether the menu should be open animated.
    
    */
    open func openMenu(_ animated: Bool) {
        self.openMenu(animated) {_ in}
    }
    
    /**
    Opens the menu
    
    @param animated Determines whether the menu should be open animated.
    @param completion The block that is called when the toggle is open.
    
    */
    open func openMenu(_ animated: Bool, completion: ((Bool) -> Void)!) {
        if !self.menuIsEnabled {
            completion(false)
            return
        }
        self.open(menuSide, animated: animated, completion: completion)
    }
    
    /**
    Closes the open menu.
    
    @param animated Determines whether the menu should be closed animated
    
    */
    open func closeMenu(_ animated: Bool) {
        self.closeMenu(animated) {_ in}
    }
    
    /**
    Closes the open menu.
    
    @param animated Determines whether the menu should be closed animated
    @param completion The block that is called when the close is complete
    
    */
    open func closeMenu(_ animated: Bool, completion: ((Bool) -> Void)!) {
        if !self.menuIsEnabled {
            completion(false)
            return
        }
        self.closeDrawer(animated: animated, completion: completion)
    }
    
    // MARK: DrawerVisualStateDelegate functions
    open func didUpdateDrawerVisualState(_ percentVisible: CGFloat) {
        self.delegate?.didUpdateDrawerVisualState(percentVisible)
    }
}
