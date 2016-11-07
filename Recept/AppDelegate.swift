//
//  AppDelegate.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FirstTimeGuideDelegate {
    var window: UIWindow?
    
    // MARK: Dependencies
    fileprivate var applicationController: ApplicationController?
    fileprivate var applicationAssembly: ApplicationAssembly?

    // MARK: UIApplicationDelegate Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let applicationAssembly: ApplicationAssembly! = AppoteketApplicationAssembly()
        self.applicationAssembly = applicationAssembly
        self.applicationController =  applicationAssembly.applicationController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        self.window!.rootViewController = self.applicationController!.rootViewController
        self.window!.makeKeyAndVisible()
        
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "State", label: "Startad")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "State", label: "Inaktiverad")
        self.applicationController?.inactivate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.applicationAssembly?.applicationAnalyticsService().updateAppState(willHaveState: .background)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.applicationAssembly?.applicationAnalyticsService().updateAppState(willHaveState: .foreground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "State", label: "Aktiverad")
        
        if self.isFirstTimeLaunch() || self.isFirstTimeLaunchForCurrentVersion() {
            // If not dispatched async: The run loop for rootViewController and FirstTimeGuide will be the same, which will trigger unbalanced call
            DispatchQueue.main.async(execute: { () -> Void in
                FirstTimeGuideViewController.launchFromViewControllerWithDelegate(self.applicationController!.rootViewController, delegate: self, analyticsService: self.applicationAssembly!.applicationAnalyticsService())
            })
        }
        else {
            self.applicationController?.activate()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "State", label: "Avslutad")
        self.applicationAssembly?.applicationAnalyticsService().updateAppState(willHaveState: .terminated)
    }
    
    func didFinishFirstTimeGuide() {
        self.applicationController?.activate()
    }
    
    func isFirstTimeLaunch() -> Bool {
        // Always show launch guide for test envs
        /*switch AppoteketApplicationAssembly.assemblyEnvironment() {
        case .DEBUG:
            return true
        default:
            break
        }*/
        
        let hasBeenLaunchedKey = "HasBeenLaunched"
        let hasBeenLaunched = UserDefaults.standard.bool(forKey: hasBeenLaunchedKey)
        return !hasBeenLaunched
    }

    func markFirstTimeLaunch() {
        let hasBeenLaunchedKey = "HasBeenLaunched"
        UserDefaults.standard.set(true, forKey: hasBeenLaunchedKey)
        UserDefaults.standard.synchronize()
        markFirstTimeLaunchForCurrentVersion()
    }
    
    func isFirstTimeLaunchForCurrentVersion() -> Bool {
        // Always show launch guide for test envs
//        switch AppoteketApplicationAssembly.assemblyEnvironment() {
//        case .DEBUG:
//            return true
//        default:
//            break
//        }
        
        let hasBeenLaunchedKey = getVersionKey()
        let hasBeenLaunched = UserDefaults.standard.bool(forKey: hasBeenLaunchedKey)
        return !hasBeenLaunched
    }

    func markFirstTimeLaunchForCurrentVersion() {
        let hasBeenLaunchedKey = getVersionKey()
        UserDefaults.standard.set(true, forKey: hasBeenLaunchedKey)
        UserDefaults.standard.synchronize()
    }

    fileprivate func getVersionKey() -> String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let hasBeenLaunchedKey = "HasBeenLaunched_" + appVersion
        return hasBeenLaunchedKey
    }
    
    // iOS9+ delegate method
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "OpenFromURL", label: url.absoluteString)
        
        guard let applicationController = self.applicationController else {
            return false
        }
        
        return applicationController.handleOpenAppFromUrl(url)
    }
    
    // iOS9- delegate method
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        self.applicationAssembly?.applicationAnalyticsService().sendEvent("App", action: "OpenFromURL", label: url.absoluteString)
        
        guard let applicationController = self.applicationController else {
            return false
        }
        
        return applicationController.handleOpenAppFromUrl(url)
    }
}
