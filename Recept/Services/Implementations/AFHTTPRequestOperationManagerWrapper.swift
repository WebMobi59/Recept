//
//  AFHTTPRequestOperationManagerWrapper.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

class AFHTTPRequestOperationManagerWrapper: AFHTTPRequestOperationManager, RequestManager {
    public func get(_ URLString: String, parameters: Any, success: ((AFHTTPRequestOperation, Any) -> Void)!, failure: ((AFHTTPRequestOperation, NSError) -> Void)!) -> AFHTTPRequestOperation {
        return AFHTTPRequestOperation()
    }

    
    override public init!(baseURL url: URL!) {
        super.init(baseURL: url)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
