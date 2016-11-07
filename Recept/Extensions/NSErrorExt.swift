//
//  NSErrorExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-16.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

extension NSError {
    var json: String {
        let dict: [String: [String: AnyObject]] = ["error": ["domain": self.domain as AnyObject, "description": self.localizedDescription as AnyObject]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        catch {
             return ""
        }
    }
}
