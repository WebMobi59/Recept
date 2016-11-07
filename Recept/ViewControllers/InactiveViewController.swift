//
//  LaunchScreenController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-09.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class InactiveViewController: UIViewController {
    fileprivate var analyticsService: AnalyticsService!
    
    @IBOutlet weak var versionLabel: DefaultLabel!
    @IBOutlet weak var footerContainer: UIView!
    
    required public init(analyticsService: AnalyticsService!) {
        super.init(nibName: "Inactive", bundle: nil)
        self.analyticsService = analyticsService
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Add label to other binaries than production versions
        let environment = AppoteketApplicationAssembly.assemblyEnvironment()
        if environment != .production {
            self.addEnvironmentLabel(environment)
        }
        
        self.view.backgroundColor = UIColor.black
        
        self.versionLabel.text = String(format: LocalizableStrings.LoadingView.VersionTextFormat, ApplicationUtility.appVersion(), LocalizableStrings.LoadingView.CopyrightYear)
        self.versionLabel.textColor = AppoteketTheme.Colors.DiscreteTextOnBlack
    }
    
    // For debug functionality, to be able to check current configuration
    fileprivate func addEnvironmentLabel(_ environment: AssemblyEnvironment) {
        let envLabel = UILabel()
        
        envLabel.textColor = UIColor.red
        envLabel.font = AppoteketTheme.Fonts.Header
        envLabel.textAlignment = .center
        
        switch environment {
        case .debug:
            envLabel.text = "DEBUG"
            break
        case .dev:
            envLabel.text = "DEV"
            break
        case .test:
            envLabel.text = "TEST"
            break
        default:
            break
        }
        self.footerContainer.addSubview(envLabel)
        Restraint(envLabel, .width, .greaterThanOrEqual, 0).addToView(self.footerContainer)
        Restraint(envLabel, .height, .greaterThanOrEqual, 0).addToView(self.footerContainer)
        Restraint(envLabel, .centerX, .equal, self.footerContainer, .centerX, 1, 0).addToView(self.footerContainer)
        Restraint(envLabel, .bottom, .equal, self.footerContainer, .bottom, 1, -30).addToView(self.footerContainer)
    }
    
    open func addAsSubviewFor(_ view: UIView!) {
        self.view.frame = UIScreen.main.bounds
        self.view.alpha = 1
        view.addSubview(self.view)
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
                    completion?(done)
                }
            )
        }
    }
}
