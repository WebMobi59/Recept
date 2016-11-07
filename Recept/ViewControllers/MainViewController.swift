//
//  ViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import UIKit

public protocol MainViewDelegate: class, WebNativeBridge {
    
}

open class MainViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate, ApplicationMainViewDelegate {
    weak var delegate: MainViewDelegate?
    fileprivate var analyticsService: AnalyticsService!
    fileprivate var isWebViewRequestAnimated: Bool = false
    
    @IBOutlet weak var webView: UIWebView!
    
    required public init(analyticsService: AnalyticsService!) {
        super.init(nibName: "Main", bundle: nil)
        self.analyticsService = analyticsService
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }
    
    fileprivate func setupWebView() {
        self.webView.delegate = self
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.delegate = self
        self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        self.webView.keyboardDisplayRequiresUserAction = false;
        self.webView.disableLongPressGestures()
    }
    
    // MARK: MainViewDelegate
    open func executeCallback(_ callbackEvent: String, callbackArgs: Dictionary<String, AnyObject>?) {
        do {
            try WebToNativeUtility.callbackJavascript(self.webView, callbackEvent: callbackEvent, callbackArgs: callbackArgs)
        }
        catch {
            Log.d("Error was thrown in executeCallback!")
        }
    }
    
    open func loadUrl(_ url: URL) {
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
        self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    open func loadUrlAnimated(_ url: URL) {
        self.webView.alpha = 0
        self.loadUrl(url)
        AnimationUtility.animate(AppoteketTheme.Animation.DefaultDuration) {
            self.webView.alpha = 1
        }
    }
    
    // Disable user interaction on webview while menu is open
    open func menuOpenPercentChanged(_ openPercent: CGFloat) {
        if openPercent > CGFloat.leastNormalMagnitude && self.webView.isUserInteractionEnabled {
            self.webView.isUserInteractionEnabled = false
        }
        else if openPercent < CGFloat.leastNormalMagnitude && !self.webView.isUserInteractionEnabled {
            self.webView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: UIWebviewDelegate
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url, let delegate = self.delegate else {
            return false
        }
        
        if delegate.isNativeUrl(url) {
            do {
                try delegate.handleNativeUrl(url, fromWebView: self.webView)
            }
            catch let error as NSError {
                Log.d("Error trying to execute native function: \n\(error)")
            }
            
            return false
        }
        else if url.scheme == "file" && !self.isWebViewRequestAnimated && self.webView.request?.url?.absoluteString != request.url?.absoluteString {
            self.isWebViewRequestAnimated = true
            self.loadUrlAnimated(url)
            return false
        }
        else {
            self.isWebViewRequestAnimated = false
        }
        
        return true
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        // Disable bounce to get more of a native feeling
        self.webView.scrollView.bounces = self.webView.scrollView.contentSize.height > self.webView.frame.height
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        guard error != nil else { return }
        
        if error._code != 102 { // 102 = Frame load interrupted, happens when redirected on login which is okay
            Log.d("---Failed loading:---\n%@\n---", args: error._domain)
        }
    }
}

