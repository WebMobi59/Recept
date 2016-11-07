//
//  ReceptTests.swift
//  ReceptTests
//
//  Created by Daniel Lervik on 2015-07-20.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import UIKit
import XCTest
import Recept_UnitTests

class GivenCachedTemplateRepository_WhenLoad_WithMatchingRevision: TestCaseBase {
    var error: NSError?
    var cachedTemplateRepository: CachedTemplateRepository?
    
    override func setUp() {
        self.cachedTemplateRepository = CachedTemplateRepository(templateStorage: StorageStub_Revision_1(), templateDownloader: TemplateDownloaderStub_Revision_1())
        
        let expectation = expectationWithDescription("Revision result")
        
        self.cachedTemplateRepository?.load(
            {
                (percentDownloaded) -> Void in
            },
            completion:
            {
                (isUpdated, error) -> Void in
                self.error = error
                expectation.fulfill()
            }
        )
        
        waitForExpectationsWithTimeout(super.waitTimeout, handler:nil)
    }
    
    func test_ShouldHaveNoError() {
        XCTAssertNil(error)
    }
    
    func test_IsLoaded() {
        XCTAssertTrue(self.cachedTemplateRepository!.isLoaded)
    }
}

class StorageStub_Revision_1: StorageStub {
    override func readDataFromFile(pathRelativeToRoot: String) -> NSData? {
        let revision = "{\"revision\":\"revision1\"}"
        return revision.dataUsingEncoding(NSUTF8StringEncoding)
    }
}

class TemplateDownloaderStub_Revision_1: TemplateDownloaderStub {
    override func getRevision(success: ((String) -> Void)!, failure: ((NSError!) -> Void)!) {
        success("revision1")
    }
}