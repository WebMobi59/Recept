//
//  GoogleAnalyticsService.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-11-09.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class GoogleAnalyticsService: NSObject, AnalyticsService {
    var dispatchHandler: ((GAIDispatchResult) -> Void)?
    let tracker: GAITracker
    let ga: GAI
    let defaultDispatchInterval: TimeInterval = 120
    
    public init(trackingId: String, debug: Bool) {
        self.ga = GAI.sharedInstance()
        self.tracker = ga.tracker(withTrackingId: trackingId)
        
        ga.dispatchInterval = self.defaultDispatchInterval
        
        ga.trackUncaughtExceptions = true
        
        if debug {
            ga.logger.logLevel = .verbose
        }
        else {
            ga.logger.logLevel = .none
        }
    }
    
    open var clientId: String! {
        get {
            return self.tracker.get(kGAIClientId)
        }
    }
    
    open func sendScreenView(_ title: String) {
        let args = GAIDictionaryBuilder
            .createScreenView()
            .set(title, forKey: kGAIScreenName)
            .build()
        self.send(args!)
    }
    
    open func sendEvent(_ category: String, action: String, label: String) {
        let args = GAIDictionaryBuilder
            .createEvent(
                withCategory: category,
                action: action,
                label: label,
                value: 0)
            .build()
        self.send(args!)
    }
    
    open func sendEvent(_ category: String, action: String, label: String, value: CGFloat) {
        let args = GAIDictionaryBuilder
            .createEvent(
                withCategory: category,
                action: action,
                label: label,
                value: value as NSNumber!)
            .build()
        self.send(args!)
    }
    
    fileprivate func send(_ parameters: NSMutableDictionary) {
        self.tracker.send(parameters as [NSObject: AnyObject]!)
    }
    
    open func updateAppState(willHaveState state: AnalyticsServiceDispatchState) {
        switch state {
        case .terminated, .background:
            self.dispatchHitsInBackground()
            break
        case .foreground:
            self.dispatchHitsNormally()
            break
        }
    }
    open func updateAppState(willBeActive active: Bool) {
        
    }
    
    /**
     Makes the analytics service dispatch hits in background (to catch e.g. willEnterBackground hits)
     
     Intended to be called on lifecycle events when app needs to dispatch immediately.
     
     Read more? - https://developers.google.com/analytics/devguides/collection/ios/v3/dispatch
     */
    fileprivate func dispatchHitsInBackground() {
        weak var weakSelf: GoogleAnalyticsService? = self
        var taskExpired = false
        let taskId = UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            taskExpired = true
        })
        
        if taskId == UIBackgroundTaskInvalid {
            return
        }
        
        self.dispatchHandler = {(result) -> Void in
            if weakSelf != nil && result == .good && !taskExpired {
                weakSelf!.ga.dispatch(completionHandler: weakSelf!.dispatchHandler)
            }
            else {
                UIApplication.shared.endBackgroundTask(taskId)
            }
        }
        
        self.ga.dispatch(completionHandler: self.dispatchHandler)
    }
    
    /**
     Restores the dispatch interval because dispatchHitsInBackground has disabled automatic dispatching.
     
     Intended to be called on lifecycle events when app can dispatch regularly on intervals.
     */
    fileprivate func dispatchHitsNormally() {
        self.ga.dispatchInterval = self.defaultDispatchInterval
    }
}
