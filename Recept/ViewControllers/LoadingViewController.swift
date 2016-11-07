//
//  LoadingViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-17.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import UIKit

public protocol LoadingViewDelegate: class {
    func didSucceedLoadingTemplates(_ isUpdated: Bool)
}

open class LoadingViewController: UIViewController, ApplicationLoadingViewDelegate {
    weak var delegate: LoadingViewDelegate?
    var templateRepository: TemplateRepository!
    var analyticsService: AnalyticsService!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var loadingFailedLabel: DefaultLabel!
    @IBOutlet weak var retryButton: GreenButton!
    @IBOutlet weak var versionLabel: DefaultLabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    required public init(analyticsService: AnalyticsService!, templateRepository: TemplateRepository) {
        self.analyticsService = analyticsService
        self.templateRepository = templateRepository
        super.init(nibName: "Loader", bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.progressBar.alpha = 0
        
        self.loadingFailedLabel.text = LocalizableStrings.LoadingView.LoadingFailedMessage
        self.loadingFailedLabel.alpha = 0
        self.loadingFailedLabel.textColor = AppoteketTheme.Colors.DefaultTextOnBlack
        
        self.retryButton.title = LocalizableStrings.LoadingView.RetryButtonTitle
        self.retryButton.isEnabled = true
        self.retryButton.alpha = 0
        self.versionLabel.text = String(format: LocalizableStrings.LoadingView.VersionTextFormat, ApplicationUtility.appVersion(), LocalizableStrings.LoadingView.CopyrightYear)
        self.versionLabel.textColor = AppoteketTheme.Colors.DiscreteTextOnBlack
    }
    
    open func loadTemplates() {
        self.startLoading()
    }
    
    open func startLoading() {
        self.retryButton.isEnabled = false
        self.showLoading()
        
        // Always start loading with some progress to show the user it's on going
        self.progressZero()
        
        let priority = DispatchQueue.GlobalQueuePriority.low
        DispatchQueue.global(priority: priority).async {
            // Do loading stuff on other thread
            self.templateRepository.load(
                {
                    (percentDownloaded) in
                    DispatchQueue.main.async {
                        if self.progressBar.alpha != 1 {
                            AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration) {
                                self.progressBar.alpha = 1
                            }
                        }
                        self.updateProgress(percentDownloaded)
                    }
                },
                completion: {
                    (isUpdated, error) -> Void in
                    DispatchQueue.main.async {
                        self.hideLoading()
                        if error == nil {
                            if self.progressBar.alpha != 0 {
                                AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration) {
                                    self.progressBar.alpha = 0
                                }
                            }
                            self.didRefreshTemplates(isUpdated)
                        }
                        else {
                            self.failedLoadingTemplatesWithError(error)
                        }
                    }
                }
            )
        }
    }
    
    fileprivate let offsetProgress: CGFloat = 0.1
    fileprivate func updateProgress(_ percentDownloaded: CGFloat) {
        let progress = percentDownloaded //offsetProgress + ((1 - offsetProgress) * percentDownloaded)
        self.progressBar.setProgress(progress, animated: true)
    }
    
    fileprivate func progressZero() {
        self.progressBar.setProgress(0, animated: false)
    }
    
    fileprivate func didRefreshTemplates(_ isUpdated: Bool) {
        // When completed, hide the view
        self.delegate?.didSucceedLoadingTemplates(isUpdated)
    }
    
    fileprivate func failedLoadingTemplatesWithError(_ error: NSError!) {
        self.hideLoading()
        // When completed, hide the view
        Log.d("---Failed loading with error:---\n\(error)\n---")
        self.retryButton.isEnabled = true
        
        self.progressZero()
        if self.retryButton.alpha < 1 {
            self.showRetry()
        }
    }
    
    fileprivate func showRetry() {
        AnimationUtility.animate() {
            self.retryButton.alpha = 1
            self.loadingFailedLabel.alpha = 1
        }
    }
    
    fileprivate func showLoading() {
        self.loadingIndicator.startAnimating()
        AnimationUtility.animate(AppoteketTheme.Animation.MediumDuration) {
            self.loadingIndicator.alpha = 1
            self.loadingFailedLabel.alpha = 0
            self.retryButton.alpha = 0
        }
    }
    
    fileprivate func hideLoading() {
        AnimationUtility.animate(
            AppoteketTheme.Animation.MediumDuration,
            animations:
            {
                () -> Void in
                self.loadingIndicator.alpha = 0
            }, completion:
            {
                (_) -> Void in
                self.loadingIndicator.stopAnimating()
            }
        )
    }
    
    @IBAction func didTapRetry(_ sender: GreenButton) {
        self.startLoading()
    }
}
