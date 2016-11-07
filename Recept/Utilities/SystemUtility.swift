//
//  SystemUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-11-19.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class SystemUtility {
    fileprivate static let info = Bundle.main.infoDictionary
    open static var appVersion: String {
        get {
            guard let version = info?["CFBundleShortVersionString"] as? String else {
                return "unknown"
            }
            return version
        }
    }
    
    open static var appBuild: String {
        get {
            guard let build = info?["CFBundleVersion"] as? String else {
                return "unknown"
            }
            return build
        }
    }
}
