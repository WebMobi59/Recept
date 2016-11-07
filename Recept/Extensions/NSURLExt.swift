//
//  NSURLExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-22.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension URL{
    func queryParams() -> [String:AnyObject] {
        var info : [String:AnyObject] = [String:AnyObject]()
        if let queryString = self.query{
            for parameter in queryString.components(separatedBy: "&"){
                let parts = parameter.components(separatedBy: "=")
                if parts.count > 1{
                    let key = (parts[0] as String).removingPercentEncoding
                    let value = (parts[1] as String).removingPercentEncoding
                    if key != nil && value != nil{
                        info[key!] = value as AnyObject?
                    }
                }
            }
        }
        return info
    }
}
