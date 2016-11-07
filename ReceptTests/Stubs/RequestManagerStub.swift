//
//  RequestManagerStub.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Recept_UnitTests

public class RequestManagerStub: NSObject, RequestManager {
    public var baseURL: NSURL! {
        fatalError("baseUrl has not been implemented")
    }
    
    public func GET(URLString: String!, parameters: AnyObject!, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)!, failure: ((AFHTTPRequestOperation!, NSError!) -> Void)!) -> AFHTTPRequestOperation! {
        fatalError("GET has not been implemented")
    }
}