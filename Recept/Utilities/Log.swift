//
//  Log.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class Log {
    open static func d(_ format: String, args: CVarArg...) {
        Log.log(format, args: args)
    }
    
    // Only log to DEBUG and DEV environment since NSLog is publicly visible
    fileprivate static func log(_ format: String, args: [CVarArg]) {
        let env = AppoteketApplicationAssembly.assemblyEnvironment()
        if env == .debug {
            if args.count > 0 {
                NSLog(String(format: format, arguments: args))
            }
            else {
                NSLog(format)
            }
        }
    }
}
