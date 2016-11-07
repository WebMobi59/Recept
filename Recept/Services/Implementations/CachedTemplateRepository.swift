//
//  TemplateRepository.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-17.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class CachedTemplateRepository: NSObject, TemplateRepository {
    public func load(_ progress: @escaping (CGFloat) -> Void, completion: @escaping (_ isUpdated: Bool, _ error: NSError?) -> Void) {
        
        self.updateTemplatesIfNeeded(progress) { (isUpdated, error) in
            self.isLoadedState = (error == nil)
            completion(isUpdated, error)
        }
        
//        self.updateTemplatesIfNeeded(progress) {
//            (isUpdated, error) in
//            // Indicate that templates are loaded if no error
//            self.isLoadedState = (error == nil)
//
//            completion(isUpdated, error)
//        }

    }



    // MARK: Dependencies
    fileprivate let templateStorage: Storage!
    fileprivate let templateDownloader: TemplateDownloader!
    
    // MARK: Dependency injected init function
    required public init(templateStorage: Storage, templateDownloader: TemplateDownloader) {
        self.templateStorage = templateStorage
        self.templateDownloader = templateDownloader
    }
    
    // MARK: TemplateRepository implementation
    open var entryUrl: URL {
        get { return try! URL(string: "#/", relativeTo: templateStorage.storageUrl().appendingPathComponent(self.localEntryFile))! }
        set {}
    }
    open var loggedOutUrl: URL {
        get { return try! URL(string: "#/logout", relativeTo: templateStorage.storageUrl().appendingPathComponent(self.localEntryFile))! }
        set {}
    }
    open var basketUrl: URL {
        get { return try! URL(string: "#/varukorg", relativeTo: templateStorage.storageUrl().appendingPathComponent(self.localEntryFile))! }
        set {}
    }
    open var menuUrlUnauthorized: URL {
        get { return try! templateStorage.storageUrl().appendingPathComponent(self.localMenuFile) }
        set {}
    }
    open var menuUrlAuthorized: URL {
        get { return try! URL(string: "#/menuauthorized", relativeTo: templateStorage.storageUrl().appendingPathComponent(self.localMenuFile))! }
        set {}
    }
    open var isLoaded: Bool {
        get { return self.isLoadedState }
        set {}
    }
    
    /**
    Loads the templates if not loaded already
    */
//    public func load(_ progress: @escaping (CGFloat) -> Void, completion: @escaping (_ isUpdated: Bool, _ error: NSError?)  -> Void) {
//        self.updateTemplatesIfNeeded(progress) {
//            (isUpdated, error) in
//            // Indicate that templates are loaded if no error
//            self.isLoadedState = (error == nil)
//            
//            completion(isUpdated, error)
//        }
//    }
    
    // Checks if an url matches to be a menu path
    open func isMenuUrl(_ url: URL) -> Bool {
        let file = url.lastPathComponent
        if file == self.menuFile {
            return true
        }
        return false
    }
    
    // MARK: Private
    fileprivate let menuFile = "menu.html"
    fileprivate let localTemplateZip = "webTemplates.zip"
    fileprivate let localTemplateRoot = "app"
    fileprivate let localRevisionFile = "app/revision.json"
    fileprivate let localEntryFile = "app/appoteket/index.html"
    fileprivate let localMenuFile = "app/appoteket/menu.html"
    
    fileprivate var isLoadedState: Bool = false
    
    fileprivate func storedTemplateRevision() throws -> String? {
        let currentData = try templateStorage.readDataFromFile(self.localRevisionFile)
        
        if currentData != nil {
            do {
                let json = try JSONSerialization.jsonObject(with: currentData!, options: []) as! [String:Any]
                return json["revision"] as? String
            } catch let error as NSError {
                print(error)
            }
        }
        else {
            return nil
        }
        return nil
    }
    
    fileprivate func checkRevision(_ completion: @escaping (_ isOutdated: Bool, _ error: NSError?) -> Void) {
        // Fetch local revision
        let previousTemplateRevision: String?
        do {
            previousTemplateRevision = try self.storedTemplateRevision()
        }
        catch let readError as NSError {
            completion(true, readError)
            return
        }
        
        guard previousTemplateRevision != nil else {
            completion(true, nil)
            return
        }
        
        templateDownloader.getRevision(
            {
                (revision) -> Void in
                completion(previousTemplateRevision != revision, nil)
            },
            failure: {
                (error) -> Void in
                completion(true, error)
            }
        )
    }
    
    fileprivate func updateTemplatesIfNeeded(_ progress: @escaping (CGFloat) -> Void, completion: @escaping (_ isUpdated: Bool, _ error: NSError?) -> Void) {
        self.checkRevision() {
            (isOutdated, error) in
            if error != nil || isOutdated {
                self.updateTemplates(progress, completion: completion)
            }
            else {
                completion(false, error)
            }
        }
    }
    
    fileprivate func updateTemplates(_ progress: @escaping (CGFloat) -> Void, completion: @escaping (_ isUpdated: Bool, _ error: NSError?) -> Void) {
        // Get url to save templates to
        let templateStorageUrl: URL?
        let templateStorageError: NSError?
        do {
            templateStorageUrl = try self.templateStorage.storageUrl() as URL
            templateStorageError = nil
        }
        catch let error as NSError {
            templateStorageUrl = nil
            templateStorageError = error
        }
        
        guard templateStorageError == nil && templateStorageUrl != nil else {
            completion(false, templateStorageError)
            return
        }
        
        // The absolute zip path
        let zipDestinationUrl = templateStorageUrl!.appendingPathComponent(self.localTemplateZip)
        
        // Get the templates
        self.templateDownloader.getAndSaveTemplateZip(self.localTemplateZip,
            progress: {
                (percentDownloaded) -> Void in
                progress(percentDownloaded)
            },
            success: {
                () -> Void in
                let unzipResult = self.unzipTemplatesToTemplateRoot(zipDestinationUrl.path, toDestination: templateStorageUrl!.appendingPathComponent(self.localTemplateRoot).path)
                if !unzipResult {
                    completion(false, NSError(domain: "UnzipError", code: 999, userInfo: nil))
                }
                else {
                    completion(true, nil)
                }
            },
            failure: {
                (error) -> Void in
                completion(false, error)
            }
        )
    }
    
    fileprivate func unzipTemplatesToTemplateRoot(_ zipPath: String, toDestination: String) -> Bool {
        return SSZipArchive.unzipFile(atPath: zipPath, toDestination: toDestination)
    }
}
