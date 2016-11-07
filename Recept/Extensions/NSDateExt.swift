//
//  NSDateExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-15.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

extension Date {
    var jsonFormat: String {
        get {
            let date = self
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let dateString = formatter.string(from: date)
            return dateString
        }
    }
}
