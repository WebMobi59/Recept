//
//  UrlSession.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol UrlSession {
    func downloadTaskWithURL(_ url: URL, progressHandler: ((_ percentDownloaded: CGFloat) -> Void)?, completionHandler: ((URL?, URLResponse?, NSError?) -> Void)!) -> URLSessionDownloadTask
}
