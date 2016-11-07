//
//  ApplicationUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-17.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation
open class ApplicationUtility {
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
