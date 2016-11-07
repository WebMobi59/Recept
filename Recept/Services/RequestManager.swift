//
//  RequestManager.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol RequestManager {
    var baseURL: URL! { get }
    func get(_ URLString: String, parameters: Any, success: ((_ operation: AFHTTPRequestOperation, _ responseObject: Any) -> Void)! , failure: ((_ operation: AFHTTPRequestOperation, _ error: NSError) -> Void)!) -> AFHTTPRequestOperation
}
