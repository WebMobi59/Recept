//
//  AppoteketApplicationAssembly.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-02.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class AppoteketApplicationAssembly: NSObject, ApplicationAssembly {
    fileprivate static let analyticsService: AnalyticsService! = AppoteketApplicationAssembly.createAnalyticsService()
    fileprivate static let inactiveTimeoutMinutes: Int = AppoteketApplicationAssembly.authenticationInactiveTimeoutMinutes()
    fileprivate static let inactiveViewController: InactiveViewController! = InactiveViewController(analyticsService: analyticsService)
    fileprivate static let baseUrl: URL! = AppoteketApplicationAssembly.apiBaseUrl()
    fileprivate static let urlSession: UrlSession! = NSURLSessionWrapper()
    fileprivate static let requestManager: RequestManager! = AFHTTPRequestOperationManagerWrapper(baseURL: baseUrl)
    fileprivate static let fileManager: FileManager! = NSFileManagerWrapper()
    fileprivate static let geoPositionService: GeoPositionService = CoreGeoPositionService(analyticsService: analyticsService)
    fileprivate static let templateStorage: Storage! = MemoryCardStorage(fileManager: fileManager)
    fileprivate static let templateDownloader: TemplateDownloader! = ApiClient(storage: templateStorage, requestManager: requestManager, urlSession: urlSession)
    fileprivate static let templateRepository: TemplateRepository! = CachedTemplateRepository(templateStorage: templateStorage, templateDownloader: templateDownloader)
    fileprivate static let httpCookieStorage: HttpCookieStorage! = NSHttpCookieStorageWrapper()
    fileprivate static let cookieStorage: CookieStorage! = SandboxedCookieStorage(httpCookieStorage: httpCookieStorage)
    fileprivate static let topViewController: TopViewController! = TopViewController(analyticsService: analyticsService)
    fileprivate static let loadingViewController: LoadingViewController! = LoadingViewController(analyticsService: analyticsService, templateRepository: templateRepository)
    fileprivate static let lockUIViewController: LockUIViewController! = LockUIViewController(analyticsService: analyticsService)
    fileprivate static let externalUrlViewController: ExternalUrlViewController! = ExternalUrlViewController(analyticsService: analyticsService)
    fileprivate static let menuViewController: MenuViewController! = MenuViewController(analyticsService: analyticsService, templateRepository: templateRepository)
    fileprivate static let mainViewController: MainViewController! = MainViewController(analyticsService: analyticsService)
    
    fileprivate static let applicationViewController: ApplicationViewController! = ApplicationViewController(
        analyticsService: analyticsService,
        templateRepository: templateRepository,
        cookieStorage: cookieStorage,
        geoPositionService: geoPositionService,
        inactiveTimeoutMinutes: inactiveTimeoutMinutes,
        mainViewController: mainViewController,
        menuViewController: menuViewController,
        topViewController: topViewController,
        loadingViewController: loadingViewController,
        inactiveViewController: inactiveViewController,
        lockUIViewController: lockUIViewController,
        externalUrlViewController: externalUrlViewController)
    
    // MARK: Public accessors
    // Set delegates for cross-dependencies
    public override init() {
        // Set the needed delegates for the application flow controller
        AppoteketApplicationAssembly.applicationViewController.mainDelegate = AppoteketApplicationAssembly.mainViewController
        AppoteketApplicationAssembly.applicationViewController.menuDelegate = AppoteketApplicationAssembly.menuViewController
        AppoteketApplicationAssembly.applicationViewController.topDelegate = AppoteketApplicationAssembly.topViewController
        AppoteketApplicationAssembly.applicationViewController.loadingDelegate = AppoteketApplicationAssembly.loadingViewController
        AppoteketApplicationAssembly.applicationViewController.lockUIDelegate = AppoteketApplicationAssembly.lockUIViewController
        AppoteketApplicationAssembly.applicationViewController.externalUrlDelegate = AppoteketApplicationAssembly.externalUrlViewController
        
        // Set needed delegates for sub views
        AppoteketApplicationAssembly.mainViewController.delegate = AppoteketApplicationAssembly.applicationViewController
        AppoteketApplicationAssembly.menuViewController.delegate = AppoteketApplicationAssembly.applicationViewController
        AppoteketApplicationAssembly.topViewController.delegate = AppoteketApplicationAssembly.applicationViewController
        AppoteketApplicationAssembly.loadingViewController.delegate = AppoteketApplicationAssembly.applicationViewController
        AppoteketApplicationAssembly.externalUrlViewController.delegate = AppoteketApplicationAssembly.applicationViewController
    }
    
    // Based on target swift flags
    open static func assemblyEnvironment() -> AssemblyEnvironment {
        #if UNITTESTS
            return .unittests
        #else
            #if DEBUG
                return .debug
            #else
                #if DEV
                    return .dev
                #else
                    #if TEST
                        return .test
                    #else
                        return .production // Default, actually not defined as a flag for compiler
                    #endif
                #endif
            #endif
        #endif
    }
    
    open func applicationAnalyticsService() -> AnalyticsService! {
        return AppoteketApplicationAssembly.analyticsService
    }
    
    // The root view controller for the application
    open func applicationController() -> ApplicationController! {
        return AppoteketApplicationAssembly.applicationViewController
    }
    
    // MARK: Analytics configuration
    fileprivate static func createAnalyticsService() -> AnalyticsService! {
        return GoogleAnalyticsService(trackingId: AppoteketApplicationAssembly.googleAnalyticsTrackingId(), debug: AppoteketApplicationAssembly.googleAnalyticsDebug())
    }
    
    fileprivate static func googleAnalyticsTrackingId() -> String! {
        if let trackingId = AppoteketApplicationAssembly.googleAnalyticsConfiguration["TrackingId"] as? String {
            return trackingId
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load TrackingId")
    }
    
    fileprivate static func googleAnalyticsDebug() -> Bool! {
        if let debug = AppoteketApplicationAssembly.googleAnalyticsConfiguration["Debug"] as? Bool {
            return debug
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load Debug")
    }
    
    fileprivate static var googleAnalyticsConfiguration: Dictionary<String, AnyObject> {
        if let googleAnalytics = AppoteketApplicationAssembly.configuration["GoogleAnalytics"] as? Dictionary<String, AnyObject> {
            return googleAnalytics
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load GoogleAnalytics")
    }
    
    // MARK: Authentication configuration
    fileprivate static func authenticationInactiveTimeoutMinutes() -> Int! {
        if let inactiveTimeoutMinutes = AppoteketApplicationAssembly.authenticationConfiguration["InactiveTimeoutMinutes"] as? Int {
            return inactiveTimeoutMinutes
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load InactiveTimoutMinutes")
    }
    
    fileprivate static var authenticationConfiguration: Dictionary<String, AnyObject> {
        if let authentication = AppoteketApplicationAssembly.configuration["Authentication"] as? Dictionary<String, AnyObject> {
            return authentication
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load Authentication")
    }
    
    // MARK: API configuration
    fileprivate static func apiBaseUrl() -> URL! {
        if let baseUrl = AppoteketApplicationAssembly.apiConfiguration["BaseUrl"] as? String {
            if let url = URL(string: baseUrl) {
                return url
            }
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load BaseUrl")
    }
    
    fileprivate static var apiConfiguration: Dictionary<String, AnyObject> {
        if let apiConfig = AppoteketApplicationAssembly.configuration["Api"] as? Dictionary<String, AnyObject> {
            return apiConfig
        }
        
        fatalError("AppoteketApplicationAssembly: Could not load Api")
    }
    
    fileprivate static var configurationFile: String {
        var assemblyFile: String
        switch (AppoteketApplicationAssembly.assemblyEnvironment()) {
        case .unittests:
            assemblyFile = "Configuration.UnitTests"
        case .debug:
            assemblyFile = "Configuration.Debug"
            break
        case .dev:
            assemblyFile = "Configuration.Dev"
            break
        case .test:
            assemblyFile = "Configuration.Test"
            break
        default:
            assemblyFile = "Configuration.Production"
            break
        }
        return Bundle.main.path(forResource: assemblyFile, ofType: "plist")!
    }
    
    fileprivate static var configuration: Dictionary<String, AnyObject> {
        if let config = NSDictionary(contentsOfFile: AppoteketApplicationAssembly.configurationFile) as? Dictionary<String, AnyObject> {
            return config
        }
        
        fatalError("AppoteketApplicationAssembly: Could not read configuration file")
    }
}
