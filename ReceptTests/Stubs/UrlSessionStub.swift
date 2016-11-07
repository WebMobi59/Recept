//
//  UrlSessionStub.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Recept_UnitTests
class UrlSessionStub: NSObject, UrlSession {
    func downloadTaskWithURL(url: NSURL, progressHandler: ((percentDownloaded: CGFloat) -> Void)?, completionHandler: ((NSURL!, NSURLResponse?, NSError?) -> Void)!) -> NSURLSessionDownloadTask {
        fatalError("downloadTaskWithURL has not been implemented")
    }
}