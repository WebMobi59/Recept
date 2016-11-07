//
//  ExternalUrlViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-19.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import UIKit

public protocol ExternalUrlViewDelegate: class, WebNativeBridge {
    
}

open class ExternalUrlViewControllerError : NSError {
    
}

open class ExternalUrlViewController: UIViewController, UIWebViewDelegate, ApplicationExternalUrlViewDelegate
{
    fileprivate var analyticsService: AnalyticsService!
    
    weak var delegate: ExternalUrlViewDelegate?
    var currentCallbackOnClose: ((_ nativeUrl: URL?) -> Void)?
    var webView: UIWebView?
    @IBOutlet weak var closeButton: DrawerButton!
    @IBOutlet weak var topSeparatorLine: UIView!
    @IBOutlet weak var header: HeaderLabel!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var navigateLeft: ArrowButtonLeft!
    @IBOutlet weak var navigateRight: ArrowButtonRight!
    
    required public init(analyticsService: AnalyticsService!) {
        super.init(nibName: "ExternalUrl", bundle: nil)
        self.analyticsService = analyticsService
        self.view.layoutIfNeeded() // Force view to load early, so that we can setup default values
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    fileprivate func setup() {
        self.topSeparatorLine.backgroundColor = AppoteketTheme.Colors.TopSeparator
        self.header.text = nil
        self.navigateLeft.isEnabled = false
        self.navigateRight.isEnabled = false
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.resetWebView()
            self.doCloseCallbackIfPresent(nil)
        }
    }
    
    fileprivate func doCloseCallbackIfPresent(_ nativeUrl: URL?) {
        if let callbackOnClose = self.currentCallbackOnClose {
            callbackOnClose(nativeUrl)
            self.currentCallbackOnClose = nil
        }
    }
    
    fileprivate func resetWebView() {
        self.webView?.removeFromSuperview()
        self.webView = nil
    }
    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url, let delegate = self.delegate else {
            return false
        }
        
        if delegate.isNativeUrl(url) {
            self.dismiss(animated: true) { () -> Void in
                self.doCloseCallbackIfPresent(url)
            }
            return false
        }
        else {
            return true
        }
    }
    
    fileprivate func isGoogleMapsAppUrl(_ url: URL) -> Bool {
        return url.scheme == "comgooglemaps" || url.scheme == "comgooglemapsurl"
    }
    
    fileprivate func canOpenUrl(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    open func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigateLeft.isEnabled = webView.canGoBack
        self.navigateRight.isEnabled = webView.canGoForward
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.navigateLeft.isEnabled = webView.canGoBack
        self.navigateRight.isEnabled = webView.canGoForward
    }
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        self.navigateLeft.isEnabled = webView.canGoBack
        self.navigateRight.isEnabled = webView.canGoForward
        
        if self.isGoogleMapsUrlLoaded() {
            self.hideGoogleMapsAppPromotion()
        }
    }
    
    fileprivate func isGoogleMapsUrlLoaded() -> Bool {
        if let host = self.webView?.request?.url?.host,
                let path = self.webView?.request?.url?.path {
            if host.hasPrefix("maps.google") || (host.contains("google") && path.hasPrefix("/maps")) {
                return true
            }
        }
        return false
    }
    
    fileprivate func hideGoogleMapsAppPromotion() {
        self.hideElementWithClass("ml-promotion-container")
    }
    
    fileprivate func hideElementWithClass(_ classIdentifier: String) {
        let css = ".\(classIdentifier) { display: none !important; }"
        let createCssNode = "var cssNode = document.createElement('style');cssNode.type = \"text/css\";"
        let createCssText = "var cssText = document.createTextNode('\(css)');"
        let appendCssTextToCssNode = "cssNode.appendChild(cssText);"
        let appendCssNodeToHead = "document.getElementsByTagName('head')[0].appendChild(cssNode);"
        let javascript = createCssNode + createCssText + appendCssTextToCssNode + appendCssNodeToHead;
        self.webView?.stringByEvaluatingJavaScript(from: javascript)
    }
    
    @IBAction func didNavigateLeft(_ sender: UIButton) {
        self.webView?.goBack()
    }
    
    @IBAction func didNavigateRight(_ sender: UIButton) {
        self.webView?.goForward()
    }
    
    open func openUrlFromViewController(_ viewController: UIViewController!, url: URL!, title: String!, callbackOnClose: ((_ nativeUrl: URL?) -> Void)!) throws {
        try self.verifyNotShowing()
        self.clearWebViewHistory()
        self.loadExternalUrl(url)
        self.header.text = title
        self.currentCallbackOnClose = callbackOnClose
        self.openFromViewController(viewController)
    }
    
    fileprivate func verifyNotShowing() throws {
        if self.currentCallbackOnClose != nil {
            throw NSError(domain: "View is already opened, and no correctly closed", code: -1, userInfo: nil)
        }
    }
    
    fileprivate func clearWebViewHistory() {
        // Only currently known way of clearing history is to recreate the webview. This is why we don't have the webview in the xib file
        self.webView = UIWebView()
        self.webView!.delegate = self
        self.webView!.backgroundColor = UIColor.white
        self.webView!.scalesPageToFit = true
        self.webView!.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        self.webView!.keyboardDisplayRequiresUserAction = false;
        self.view.addSubview(self.webView!)
        createWebViewConstraints(self.webView!)
    }
    
    fileprivate func createWebViewConstraints(_ webView: UIWebView) {
        Restraint(webView, .leading, .equal, self.view, .leading, 1, 0).addToView(self.view)
        Restraint(webView, .trailing, .equal, self.view, .trailing, 1, 0).addToView(self.view)
        Restraint(webView, .top, .equal, self.headerContainer, .bottom, 1, 0).addToView(self.view)
        Restraint(webView, .bottom, .equal, self.footerContainer, .top, 1, 0).addToView(self.view)
    }
    
    fileprivate func loadExternalUrl(_ url: URL) {
        let request = URLRequest(url: url)
        self.webView!.loadRequest(request)
    }
    
    fileprivate func openFromViewController(_ viewController: UIViewController!) {
        viewController.present(self, animated: true, completion: nil)
    }
}
