//
//  GeoPosition.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation
import CoreLocation

public struct GeoCoordinate {
    // -- Serialized parameters
    let latitude: CGFloat
    let longitude: CGFloat
    let timestamp: Date
    let accuracy: CGFloat
    var ageInSeconds: NSInteger {
        return -NSInteger(self.timestamp.timeIntervalSinceNow)
    }
    // --
    
    init(_ location: CLLocation) {
        self.latitude = CGFloat(location.coordinate.latitude)
        self.longitude = CGFloat(location.coordinate.longitude)
        self.timestamp = location.timestamp
        self.accuracy = CGFloat(location.horizontalAccuracy)
    }
    
    init(latitude: CGFloat, longitude: CGFloat) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date(timeIntervalSince1970: 0)
        self.accuracy = CGFloat.greatestFiniteMagnitude
    }
    
    init(latitude: CGFloat, longitude: CGFloat, timestamp: Date, accuracy: CGFloat) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.accuracy = accuracy
    }
    
    var json: String {
        let dict: [String: AnyObject] = ["latitude": self.latitude as AnyObject, "longitude": self.longitude as AnyObject, "timestamp": self.timestamp.jsonFormat as AnyObject, "ageInSeconds": self.ageInSeconds as AnyObject, "accuracy": self.accuracy as AnyObject]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        catch {
            return ""
        }
    }
}
