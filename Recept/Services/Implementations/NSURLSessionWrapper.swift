//
//  NSURLSessionWrapper.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class NSURLSessionWrapper: NSObject, UrlSession, URLSessionDownloadDelegate {
    fileprivate var session: Foundation.URLSession!
    
    fileprivate var completionHandler: ((URL?, URLResponse?, NSError?) -> Void)?
    fileprivate var progressHandler: ((CGFloat) -> Void)?
    
    public override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "se.apoteket.sessionConfiguration")
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    open func downloadTaskWithURL(_ url: URL, progressHandler: ((_ percentDownloaded: CGFloat) -> Void)?, completionHandler: ((URL?, URLResponse?, NSError?) -> Void)!) -> URLSessionDownloadTask {
        self.completionHandler = completionHandler
        self.progressHandler = progressHandler
        return self.session.downloadTask(with: url)
    }
    
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.completionHandler?(location, downloadTask.response, downloadTask.error as NSError?)
    }
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if (error != nil) {
            self.completionHandler?(task.currentRequest?.url, task.response, error as NSError?)
        }
    }
    
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        self.progressHandler?(percentDownloaded)
    }
}
