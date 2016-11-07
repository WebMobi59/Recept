//
//  CoreGeoPosition.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation
import CoreLocation

open class CoreGeoPositionService: NSObject, GeoPositionService, CLLocationManagerDelegate {
    /* GeoPositionService */
    open let updateEvent = Event<GeoCoordinate>()
    open let errorEvent = Event<NSError>()
    open var latestCoordinate: GeoCoordinate? {
        get {
            return self.latestLocation
        }
    }
    open var isStarted: Bool {
        get {
            return self.stopAfterSecondsTimer != nil
        }
    }
    
    open func start(_ stopAfterSeconds: TimeInterval) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.stopAfterSecondsTimer?.invalidate()
        self.stopAfterSecondsTimer = Timer.scheduledTimer(timeInterval: stopAfterSeconds, target: self, selector: #selector(CoreGeoPositionService.timeout), userInfo: nil, repeats: false)
        self.locationManager.startUpdatingLocation()
        
        // If we since earlier already have a coordinate, give it back immediately
        if let latest = self.latestCoordinate {
            self.updateEvent.emit(latest)
        }
    }
    
    open func stop() {
        if let timer = self.stopAfterSecondsTimer {
            self.locationManager.stopUpdatingLocation()
            timer.invalidate()
            self.stopAfterSecondsTimer = nil
        }
    }
    
    /****/
    fileprivate var analyticsService: AnalyticsService!
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    fileprivate var latestLocation: GeoCoordinate?
    fileprivate var stopAfterSecondsTimer: Timer?
    fileprivate var lastKnownAuthorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    
    public required init(analyticsService: AnalyticsService!) {
        super.init()
        self.analyticsService = analyticsService
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.stopAfterSecondsTimer = nil
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = GeoCoordinate(locations.last!)
        self.latestLocation = coordinate
        self.updateEvent.emit(coordinate)
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.d("Error: GeoPositionService %@", args: error.localizedDescription)
        
        let errDict = [
            NSLocalizedDescriptionKey: "Could not update position.",
            NSLocalizedFailureReasonErrorKey: "Location error."]
        self.errorEvent.emit(NSError(domain: "GeoPositionService", code: -1, userInfo: errDict))
    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
            case .restricted, .denied:
                let errDict = [
                    NSLocalizedDescriptionKey: "AuthorizationStatus is Denied or Restricted.",
                    NSLocalizedFailureReasonErrorKey: "Cannot access geo location service."]
                self.errorEvent.emit(NSError(domain: "GeoPositionService", code: -1, userInfo: errDict))
                break
            case .authorizedAlways, .authorizedWhenInUse:
                break
            default:
                break
        }
        self.lastKnownAuthorizationStatus = status
    }
    
    open func timeout() {
        self.stop()
        if let latest = self.latestCoordinate {
            self.updateEvent.emit(latest)
        }
        else {
            let errDict = [
                NSLocalizedDescriptionKey: "Timeout and no coordinate sent.",
                NSLocalizedFailureReasonErrorKey: "No location sent."]
            self.errorEvent.emit(NSError(domain: "GeoPositionService", code: -1, userInfo: errDict))
        }
    }
}
