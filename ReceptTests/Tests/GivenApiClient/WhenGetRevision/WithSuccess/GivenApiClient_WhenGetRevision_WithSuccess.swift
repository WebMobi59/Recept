//
//  ReceptTests.swift
//  ReceptTests
//
//  Created by Daniel Lervik on 2015-06-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import UIKit
import XCTest
import Recept_UnitTests

class GivenApiClient_WhenGetRevision_WithSuccess: TestCaseBase {
    private var revision: String?
    private var error: NSError?
    
    override func setUp() {
        let apiClient = ApiClient(storage: StorageStub(), requestManager: RequestManagerStub_Success_Revision_1(), urlSession: UrlSessionStub())
        
        let expectation = expectationWithDescription("Revision result")
        apiClient.getRevision(
            {
                (_revision) -> Void in
                self.revision = _revision
                expectation.fulfill()
            },
            failure: {
                (_error) -> Void in
                self.error = _error
                expectation.fulfill()
            }
        )
        waitForExpectationsWithTimeout(super.waitTimeout, handler:nil)
    }
    
    func test_ShouldHaveNoError() {
        XCTAssertNil(error)
    }
    
    func test_ShouldHaveRevision() {
        XCTAssertEqual(revision!, "revision1")
    }
    
}

class RequestManagerStub_Success_Revision_1: RequestManagerStub {
    override var baseURL: NSURL! { return NSURL(string: "http://fake/") }
    override func GET(URLString: String!, parameters: AnyObject!, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)!, failure: ((AFHTTPRequestOperation!, NSError!) -> Void)!) -> AFHTTPRequestOperation! {
        
        let request = AFHTTPRequestOperation()
        
        let response: NSDictionary = NSDictionary(object: "revision1", forKey: "revision")
        success(request, response)
        
        return request
    }
}