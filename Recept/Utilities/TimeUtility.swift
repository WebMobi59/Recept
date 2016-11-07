//
//  UptimeUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-26.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class TimeUtility {
    // Get timestamp in milliseconds from 1970
    open static func currentTime() -> Int {
        var currentTime = time_t()
        time(&currentTime)
        return currentTime
    }
    
    open static func secondsBetweenTimestamps(_ from: Int, to: Int) -> Int {
        return to - from
    }
}
