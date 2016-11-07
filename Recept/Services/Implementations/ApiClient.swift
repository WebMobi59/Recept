//
//  ApoApiClient.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-12.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class ApiClient: NSObject, TemplateDownloader {
    // MARK: Dependencies
    fileprivate let storage: Storage
    fileprivate let requestManager: RequestManager
    fileprivate let urlSession: UrlSession
    
    // MARK: Dependency injected init function
    public required init(storage: Storage, requestManager: RequestManager, urlSession: UrlSession) {
        self.storage = storage
        self.requestManager = requestManager
        self.urlSession = urlSession
    }
    
    // MARK: Template Client implementation
    open func getRevision(_ success: ((String) -> Void)!, failure: ((NSError?) -> Void)!) {
        let fromUrl = self.requestManager.baseURL.appendingPathComponent("revision.json")
        
        self.requestManager.get(fromUrl.absoluteString, parameters: [],
            success: {
                (_, result) -> Void in
                if result != nil {
                    if let resultDict = result as? Dictionary<String, AnyObject>,
                            let revision = resultDict["revision"] as? String {
                        success(revision)
                        return
                    }
                }
                failure(NSError(domain: "GetRevision", code: -1, userInfo: nil))
            },
            failure: {
                (_, error) -> Void in
                failure(error)
            }
        )
    }
    
    /**
    Fetches the current zipped template from the server and saves it locally in a file
    */
    open func getAndSaveTemplateZip(_ toFileName: String!, progress: ((_ percentDownloaded: CGFloat) -> Void)?, success: (() -> Void)!, failure: ((NSError?) -> Void)!) {
        let fromUrl = self.requestManager.baseURL.appendingPathComponent("webTemplates.zip")
        self.download(fromUrl, toFileName: toFileName, progress: progress, success: success, failure: failure)
    }
    
    // MARK: Private
    fileprivate func download(_ fromUrl: URL, toFileName: String!, progress: ((_ percentDownloaded: CGFloat) -> Void)?, success: (() -> Void)!, failure: ((NSError?) -> Void)!) {
        let session = self.urlSession
        let downloadTask = session.downloadTaskWithURL(fromUrl,
            progressHandler: {
                (percentDownloaded) -> Void in
                progress?(percentDownloaded)
            },
            completionHandler: {
                (url, response, error) -> Void in
                guard error == nil && url != nil else {
                    failure(error)
                    return
                }
                
                do {
                   try self.storage.move(url!.path, toPathRelativeToStorageRootDirectory: toFileName, removeExistingFiles: true)
                    success()
                }
                catch let error as NSError {
                    failure(error)
                }
            }
        )
        downloadTask.resume()
    }
}
