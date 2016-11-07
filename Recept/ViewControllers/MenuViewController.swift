//
//  MenuReactViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-08.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol MenuViewDelegate: class, WebNativeBridge {
    func didSelectMenuUrl(_ url: URL) -> Void
}

open class MenuViewController: UIViewController, UIWebViewDelegate, ApplicationMenuViewDelegate, UIScrollViewDelegate {
    weak var delegate: MenuViewDelegate?
    
    fileprivate var analyticsService: AnalyticsService!
    fileprivate var templateRepository: TemplateRepository!
    
    @IBOutlet weak var webView: UIWebView!
    
    required public init(analyticsService: AnalyticsService, templateRepository: TemplateRepository) {
        super.init(nibName: "Menu", bundle: nil)
        self.analyticsService = analyticsService
        self.templateRepository = templateRepository
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        self.webView.scrollView.delegate = self
        self.webView.scrollView.bounces = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        self.webView.keyboardDisplayRequiresUserAction = false;
        self.webView.disableLongPressGestures()
    }
    
    open func reloadMenu(_ authorized: Bool) {
        let menuUrl = authorized ? self.templateRepository.menuUrlAuthorized : self.templateRepository.menuUrlUnauthorized
        let request = URLRequest(url: menuUrl as URL)
        self.webView.loadRequest(request)
        self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url {
            if self.templateRepository.isMenuUrl(url) {
                return true
            }
            
            if let delegate = self.delegate {
                if delegate.isNativeUrl(url) {
                    do {
                        try delegate.handleNativeUrl(url, fromWebView: self.webView)
                    }
                    catch let error as NSError {
                        Log.d("Could not handle native url in menu! \(error)")
                    }
                }
                else {
                    delegate.didSelectMenuUrl(request.url!)
                }
                return false
            }
        }
        
        return false
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        // Avoid horizontal scrolling
        webView.updateDeviceWidth()
        
        // Disable mark/copy/paste actions from long press
        
        // Disable bounce to get more of a native feeling
        self.webView.scrollView.bounces = self.webView.scrollView.contentSize.height > self.webView.frame.height
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Avoid horizontal scrolling
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}
