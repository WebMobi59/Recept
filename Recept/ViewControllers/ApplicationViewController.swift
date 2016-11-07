//
//  RootViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-26.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol ApplicationMainViewDelegate: class {
    func loadUrl(_ url: URL)
    func executeCallback(_ callbackEvent: String, callbackArgs: Dictionary<String, AnyObject>?)
    func menuOpenPercentChanged(_ openPercent: CGFloat)
}

public protocol ApplicationMenuViewDelegate: class {
    func reloadMenu(_ authorized: Bool)
}

public protocol ApplicationTopViewDelegate: class {
    func setBasketValues(_ badge: NSInteger?, topText: String?, bottomText: String?)
    func menuOpenPercentChanged(_ openPercent: CGFloat)
}

public protocol ApplicationLoadingViewDelegate: class {
    func loadTemplates()
}

public protocol ApplicationLockUIViewDelegate: class {
    func addAsSubviewFor(_ view: UIView!)
    func removeViewAnimating(_ animated: Bool, completion: ((Bool) -> Void)?)
    var lockUIText: String? { get set }
    func setLockUITextAnimated(_ text: String?)
}

public protocol ApplicationExternalUrlViewDelegate: class {
    func openUrlFromViewController(_ viewController: UIViewController!, url: URL!, title: String!, callbackOnClose: ((_ nativeUrl: URL?) -> Void)!) throws
}

open class ApplicationViewController: UIViewController, ApplicationController, MenuViewDelegate, MainViewDelegate, TopViewDelegate, LoadingViewDelegate, DrawerVisualStateDelegate, WebNativeBridge, ExternalUrlViewDelegate
{
    fileprivate var analyticsService: AnalyticsService!
    fileprivate var templateRepository: TemplateRepository!
    fileprivate var cookieStorage: CookieStorage!
    fileprivate var geoPositionService: GeoPositionService!
    fileprivate var inactiveTimeoutMinutes: Int!
    
    fileprivate var loadingViewController: UIViewController!
    fileprivate var topViewController: UIViewController!
    fileprivate var drawerViewController: DrawerViewController!
    fileprivate var inactiveViewController: InactiveViewController!
    fileprivate var lockUIViewController: UIViewController!
    fileprivate var externalUrlViewController: UIViewController!
    
    fileprivate var inactivatedTimestamp: Int? = nil
    
    fileprivate var geoUpdateListener: Listener?
    fileprivate var geoErrorListener: Listener?
    
    weak var mainDelegate: ApplicationMainViewDelegate?
    weak var menuDelegate: ApplicationMenuViewDelegate?
    weak var topDelegate: ApplicationTopViewDelegate?
    weak var loadingDelegate: ApplicationLoadingViewDelegate?
    weak var lockUIDelegate: ApplicationLockUIViewDelegate?
    weak var externalUrlDelegate: ApplicationExternalUrlViewDelegate?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    open func inactivate() {
        if !self.view.subviews.contains(self.inactiveViewController!.view) {
            self.inactiveViewController!.addAsSubviewFor(self.view!)
            self.drawerViewController.menuIsEnabled = false
            
            // Timestamp used to check if we need to login again after returning
            self.inactivatedTimestamp = TimeUtility.currentTime()
        }
    }
    
    fileprivate func isLoginRequiredAfterInactive() -> Bool {
        let now = TimeUtility.currentTime()
        if let inactivatedTimestamp = self.inactivatedTimestamp {
            let inactivatedTime = TimeUtility.secondsBetweenTimestamps(inactivatedTimestamp, to: now)
            let inactivatedTimeoutSeconds = self.inactiveTimeoutMinutes * 60
            if inactivatedTime >= inactivatedTimeoutSeconds {
                return true
            }
        }
        return false
    }
    
    open func activate() {
        if self.isLoginRequiredAfterInactive() {
            self.logout()
        }
        
        // Always make sure user has latest templates
        self.loadTemplates()
        
        if let inactiveViewController = self.inactiveViewController {
            if self.view.subviews.contains(inactiveViewController.view) {
                inactiveViewController.removeViewAnimating(true) {
                    (_) -> Void in
                    self.drawerViewController.menuIsEnabled = true
                }
            }
        }
    }
    
    open func handleOpenAppFromUrl(_ url: URL!) -> Bool {
        guard let host = url.host else {
            return false
        }
        
        switch host {
        case "bankid":
            return self.handleBankIdRedirect(url)
        default:
            return false
        }
    }
    
    fileprivate func handleBankIdRedirect(_ url: URL!) -> Bool {
        guard
            let escapedReturnPage = url.queryParams()["returnPage"] as? String,
            let returnPage = escapedReturnPage.removingPercentEncoding
        else {
            Log.d("Could not parse url!")
            return false
        }
        
        let returnUrl = URL(string: "#/\(returnPage)", relativeTo: self.templateRepository.entryUrl)!
        self.mainDelegate?.loadUrl(returnUrl)
        
        return true
    }
    
    open func lockUI(_ text: String?) {
        if !self.view.subviews.contains(self.lockUIViewController!.view) {
            self.lockUIDelegate?.lockUIText = text
            self.lockUIDelegate?.addAsSubviewFor(self.view!)
            self.drawerViewController.menuIsEnabled = false
        }
    }
    
    open func unlockUI(_ completion: (() -> Void)?) {
        if let lockUIViewController = self.lockUIViewController {
            if self.view.subviews.contains(lockUIViewController.view) {
                lockUIDelegate?.removeViewAnimating(true) {
                    (_) -> Void in
                    self.lockUIDelegate?.lockUIText = nil
                    self.drawerViewController.menuIsEnabled = true
                    completion?()
                }
            }
        }
    }
    
    open var rootViewController: UIViewController! {
        get {
            return self
        }
    }
    
    // Init functionality
    required public init(analyticsService: AnalyticsService!, templateRepository: TemplateRepository!, cookieStorage: CookieStorage!, geoPositionService: GeoPositionService!, inactiveTimeoutMinutes: Int!, mainViewController: UIViewController!, menuViewController: UIViewController, topViewController: UIViewController!, loadingViewController: UIViewController!, inactiveViewController: InactiveViewController!, lockUIViewController: UIViewController!, externalUrlViewController: UIViewController) {
        super.init(nibName: "Application", bundle: nil)
        
        self.analyticsService = analyticsService
        self.cookieStorage = cookieStorage
        self.templateRepository = templateRepository
        self.geoPositionService = geoPositionService
        self.inactiveTimeoutMinutes = inactiveTimeoutMinutes
        
        self.topViewController = topViewController
        self.loadingViewController = loadingViewController
        self.inactiveViewController = inactiveViewController
        self.lockUIViewController = lockUIViewController
        self.externalUrlViewController = externalUrlViewController
        
        self.drawerViewController = DrawerViewController(mainViewController: mainViewController, menuViewController: menuViewController)
        self.drawerViewController.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func setup() {
        // Add the top view
        self.topView.addSubview(self.topViewController.view)
        self.topViewController.view.frame = self.topView.bounds
        
        // Add content view
        self.contentView.addSubview(self.drawerViewController.view)
        self.drawerViewController.view.frame = self.contentView.bounds
        
        // Inactive view controller until it's removed by activate
        self.inactiveViewController!.addAsSubviewFor(self.view!)
    }
    
    /**
    MenuViewDelegate action when a menu item is selected
    */
    open func didSelectMenuUrl(_ url: URL) {
        self.mainDelegate?.loadUrl(url)
        self.drawerViewController.closeMenu(true)
    }
    
    /**
    MainDelegate action when drawer is tapped
    */
    open func reloadMenu(_ authorized: Bool) {
        self.menuDelegate?.reloadMenu(authorized)
    }
    
    open func didTapDrawer() {
        self.drawerViewController.toggleMenu(true)
    }
    
    open func didTapBasket() {
        self.mainDelegate?.loadUrl(self.templateRepository.basketUrl as URL)
        self.drawerViewController.closeMenu(true)
    }
    
    open func didTapLogo() {
        self.mainDelegate?.loadUrl(self.templateRepository.entryUrl as URL)
        self.drawerViewController.closeMenu(true)
    }
    
    open func didUpdateDrawerVisualState(_ percentVisible: CGFloat) {
        self.mainDelegate?.menuOpenPercentChanged(min(percentVisible, 1.0))
        self.topDelegate?.menuOpenPercentChanged(min(percentVisible, 1.0))
    }
    
    open func setBasketBadge(_ fromWebView: UIWebView?, args: Dictionary<String, AnyObject>?, callbackEvent: String?) {
        let badge = args?["badge"] as? NSInteger
        let topText = args?["topText"] as? String
        let bottomText = args?["bottomText"] as? String
        self.topDelegate?.setBasketValues(badge, topText: topText, bottomText: bottomText)
        
        if callbackEvent != nil {
            self.mainDelegate?.executeCallback(callbackEvent!, callbackArgs: nil)
        }
    }
    
    open func login(_ returnUrl: URL) {
        self.mainDelegate?.loadUrl(returnUrl)
    }
    
    
    fileprivate func loadTemplates() {
        self.loadingViewController.view.alpha = 1
        self.view.addSubview(self.loadingViewController.view)
        self.loadingViewController.view.frame = UIScreen.main.bounds
        self.loadingDelegate?.loadTemplates()
    }
    
    // MARK: LoadingViewDelegate
    open func didSucceedLoadingTemplates(_ isUpdated: Bool) {
        if self.inactivatedTimestamp == nil || isUpdated || self.isLoginRequiredAfterInactive()  {
            URLCache.shared.removeAllCachedResponses()
            self.logout()
        }
        
        // Enable the menu
        self.drawerViewController.menuIsEnabled = true
        
        // Animate closing the loading view
        AnimationUtility.animate(AppoteketTheme.Animation.DefaultDuration, delay: AppoteketTheme.Animation.DefaultDuration,
            animations: {
                self.loadingViewController.view.alpha = 0
            },
            completion: { (_) in
                self.loadingViewController.view.removeFromSuperview()
            }
        )
    }
    
    // MARK: WebNativeBridge implementation
    open func handleNativeUrl(_ url: URL, fromWebView: UIWebView?) throws {
        if url.scheme == "auth" {
            self.handleAuthUrl(url, fromWebView: fromWebView)
            return
        }
        
        if url.scheme == "checkout" {
            self.handleCheckout(url, fromWebView: fromWebView)
            return
        }
        
        // Parse the stuff
        var (functionName, args, callbackEvent) = try WebToNativeUtility.process(url)
        
        if functionName != nil {
            switch functionName! {
            case "getAnalyticsClientId":
                let clientId = self.analyticsService.clientId
                if fromWebView != nil && callbackEvent != nil {
                    do {
                        args = ["analyticsClientId": clientId as AnyObject]
                        try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: args)
                    } catch {}
                }
                break
            case "setBasketValues":
                self.setBasketBadge(fromWebView, args: args, callbackEvent: callbackEvent)
                break
            case "lockUI":
                let lockUIText = args?["text"] as? String
                self.lockUI(lockUIText)
                break
            case "setLockUIText":
                let lockUIText = args?["text"] as? String
                self.lockUIDelegate?.setLockUITextAnimated(lockUIText)
                break
            case "unlockUI":
                self.unlockUI {
                    if fromWebView != nil && callbackEvent != nil {
                        do {
                            try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: nil)
                        } catch {}
                    }
                }
                break
            case "setApoteketDomainCookie":
                guard let
                    name = args?["name"] as? String,
                    let value = args?["value"] as? String,
                    let timeToLiveSeconds = args?["timeToLiveSeconds"] as? TimeInterval,
                    let path = args?["path"] as? String
                else {
                    break
                }
                cookieStorage.setApoteketDomainCookie(name, value: value, timeToLiveSeconds: timeToLiveSeconds, path: path)
                if callbackEvent != nil {
                    WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgsJson: nil)
                }
                break
            case "setMenuLoggedIn":
                guard let
                    isAuthorized = args?["isAuthorized"] as? Bool else {
                    break
                }
                self.menuDelegate?.reloadMenu(isAuthorized)
                if callbackEvent != nil {
                    WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgsJson: nil)
                }
                break
            case "getClientInformation":
                if callbackEvent != nil {
                    let args = [
                        "system": [
                            "os": "ios",
                            "version": OperatingSystemUtility.iOSVersionString
                        ],
                        "app": [
                            "build": SystemUtility.appBuild,
                            "version": SystemUtility.appVersion
                        ]
                    ]
                    try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: args as Dictionary<String, AnyObject>?)
                }
                break
            case "hasBankId":
                if callbackEvent != nil {
                    let args = ["result": self.canOpenBankId()]
                    try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: args as Dictionary<String, AnyObject>?)
                }
                break
            case "loginUsingBankId":
                self.drawerViewController.closeMenu(true)
                guard let
                    returnPage = args?["returnPage"] as? String,
                    let autostarttoken = args?["autostarttoken"] as? String else {
                        Log.d("No valid arguments");
                        break
                }
                
                let redirect = "se-apoteket-recept://bankid/?returnPage=\(returnPage)"
                let url = URL(string: "bankid:///?autostarttoken=\(autostarttoken)&redirect=\(redirect)")!
                let application = UIApplication.shared
                if self.canOpenBankId() {
                    self.analyticsService.sendEvent("BankID", action: "Start", label: "iOS")
                    application.openURL(url)
                }
                else {
                    try doNativeErrorCallbackWithDescription(fromWebView, callbackEvent: callbackEvent, errorMessage: "WebNativeBridge: Cannot open bankid")
                }
                break
            case "logout":
                self.drawerViewController.closeMenu(true)
                self.logout()
                break
            case "geoPositionServiceStart":
                let stopAfterSeconds = args?["stopAfterSeconds"] as? TimeInterval
                self.geoUpdateListener = self.geoPositionService.updateEvent.on {
                    coordinate in
                    WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgsJson: coordinate.json)
                }
                self.geoErrorListener = self.geoPositionService.errorEvent.on {
                    error in
                    WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgsJson: error.json)
                }
                self.geoPositionService.start(stopAfterSeconds ?? 60)
                break
            case "geoPositionServiceStop":
                self.geoUpdateListener = nil
                self.geoPositionService.stop()
                break
            case "geoPositionServiceLatestCoordinate":
                let coordinate = self.geoPositionService.latestCoordinate
                WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgsJson: coordinate?.json)
                break
            case "openExternalUrl":
                guard let
                    urlString = args?["url"] as? String,
                    let title = args?["title"] as? String
                else {
                    try doNativeErrorCallbackWithDescription(fromWebView, callbackEvent: callbackEvent, errorMessage: "WebNativeBridge: No url or title argument")
                    break
                }
                
                var url = URL(string: urlString)
                // If not possible to parse, try encoding the url first, then parse again as fallback
                if url == nil {
                    if let decodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        url = URL(string: decodedUrl)
                    }
                    
                }
                
                guard url != nil else {
                    try doNativeErrorCallbackWithDescription(fromWebView, callbackEvent: callbackEvent, errorMessage: "WebNativeBridge: No url or title argument")
                    break
                }
                
                do {
                    try self.externalUrlDelegate?.openUrlFromViewController(self, url: url, title: title) {
                        (nativeUrl: URL?) -> Void in
                        if nativeUrl != nil && self.isCheckoutUrl(nativeUrl!) {
                            do {
                                try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: nativeUrl!.queryParams())
                            } catch {}
                        }
                        else if nativeUrl != nil && self.isNativeUrl(nativeUrl!) {
                            if fromWebView != nil && callbackEvent != nil {
                                do {
                                    try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: nil)
                                } catch {}
                            }
                            self.mainDelegate?.loadUrl(nativeUrl!)
                        }
                        else if fromWebView != nil && callbackEvent != nil {
                            do {
                                try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent!, callbackArgs: nil)
                            } catch {}
                        }
                    }
                }
                catch {
                    try doNativeErrorCallbackWithDescription(fromWebView, callbackEvent: callbackEvent, errorMessage: "WebNativeBridge: Already opened an external url view")
                }
                break
            case "openExternalUrlInNativeBrowser":
                guard let
                    urlString = args?["url"] as? String,
                    let url = URL(string: urlString)
                else {
                    break
                }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
                break
            default:
                try doNativeErrorCallbackWithDescription(fromWebView, callbackEvent: callbackEvent, errorMessage: "WebNativeBridge: No native function matching for caller")
            }
        }
    }
    
    fileprivate func canOpenBankId() -> Bool {
        let bankIdUrl = URL(string: "bankid:///")!
        return UIApplication.shared.canOpenURL(bankIdUrl)
    }
    
    fileprivate func doNativeErrorCallbackWithDescription(_ fromWebView: UIWebView?, callbackEvent: String?, errorMessage: String!) throws {
        let error = NSError(domain: errorMessage, code: -1, userInfo: nil)
        if fromWebView != nil && callbackEvent != nil {
            do {
                try WebToNativeUtility.callbackJavascript(fromWebView!, callbackEvent: callbackEvent, callbackArgs: ["error": error.domain as AnyObject])
            } catch {}
        }
        throw error
    }
    
    open func handleAuthUrl(_ url: URL, fromWebView: UIWebView?) {
        if let host = url.host {
            let params = url.queryParams()
            switch host {
            case "loginCallback":
                self.didLogin(params["returnUrl"] as? String)
                break
            default:
                break
            }
        }
    }
    
    open func handleCheckout(_ url: URL, fromWebView: UIWebView?) {
        guard let host = url.host else {
            return
        }
        
        switch host {
        default:
            Log.d("Checkout! Host: %@", args: host)
            break
        }
    }
    
    open func isNativeUrl(_ url: URL) -> Bool {
        if url.scheme == "native" || self.isAuthUrl(url) || self.isCheckoutUrl(url) {
            return true
        }
        return false
    }
    
    fileprivate func isCheckoutUrl(_ url: URL) -> Bool {
        return url.scheme == "checkout"
    }
    
    fileprivate func isAuthUrl(_ url: URL) -> Bool {
        return url.scheme == "auth"
    }
    
    open func logout() {
        self.cookieStorage.clearAllCookiesExceptThoseConsideredSafe()
        self.mainDelegate?.loadUrl(self.templateRepository.entryUrl as URL)
        self.menuDelegate?.reloadMenu(false)
        self.drawerViewController.closeMenu(true)
        self.topDelegate?.setBasketValues(nil, topText: nil, bottomText: nil)
    }
    
    fileprivate func didLogin(_ returnPage: String?) {
        var absoluteUrl: URL?
        
        if returnPage != nil {
            let returnPageDecoded = returnPage?.removingPercentEncoding
            absoluteUrl = URL(string: "#/\(returnPageDecoded!)", relativeTo: self.templateRepository.entryUrl)!
        }
        else {
             absoluteUrl = URL(string: "#/", relativeTo: self.templateRepository.entryUrl as URL)!
        }
        
        self.mainDelegate?.loadUrl(absoluteUrl!)
        self.drawerViewController.closeMenu(true)
    }
}
