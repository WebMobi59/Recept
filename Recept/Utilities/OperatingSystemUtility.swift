//
//  OperatingSystemUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class OperatingSystemUtility {
    open static var iOSVersion: OperatingSystemVersion {
        var comparison = UIDevice.current.systemVersion.compare("9.0.0", options: NSString.CompareOptions.numeric)
        if comparison == .orderedSame || comparison == .orderedDescending {
            return .iOS9OrHigher
        }
        comparison = UIDevice.current.systemVersion.compare("8.0.0", options: NSString.CompareOptions.numeric)
        if comparison == .orderedSame || comparison == .orderedDescending {
            return .iOS8
        }
        else {
            return .iOS7OrLower
        }
    }
    
    open static var iOSVersionString: String {
        get {
            return UIDevice.current.systemVersion
        }
    }
}

public enum OperatingSystemVersion {
    case iOS9OrHigher
    case iOS8
    case iOS7OrLower
}
