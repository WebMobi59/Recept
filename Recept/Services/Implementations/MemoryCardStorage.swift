//
//  FileManager.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-12.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class MemoryCardStorage: NSObject, Storage {
    // MARK: Dependencies
    fileprivate var fileManager: FileManager!
    
    // MARK: Dependency injected init
    required public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: Storage implementation
    public func storageUrl() throws -> URL {
        return try self.templateRootDirectoryUrl()
    }
    
    open func move(_ fromAbsolutePath: String, toPathRelativeToStorageRootDirectory: String, removeExistingFiles: Bool) throws {
        let storageUrl = try self.storageUrl()
        let toAbsolutePath = storageUrl.appendingPathComponent(toPathRelativeToStorageRootDirectory).path
        
        try self.moveFileFromPath(fromAbsolutePath, toAbsolutePath: toAbsolutePath, replace: removeExistingFiles)
        
    }
    
    open func readDataFromFile(_ pathRelativeToRoot: String) throws -> Data? {
        let storageUrl = try self.storageUrl()
        return self.fileManager.contentsAtPath(storageUrl.appendingPathComponent(pathRelativeToRoot).path)
    }
    
    // MARK: Private accessors
    fileprivate static let storageDirectory = "templates"
    fileprivate func documentRootDirectoryUrl() throws -> URL {
        let documentsUrl = try self.fileManager.URLForDirectory(.documentDirectory, inDomain: .userDomainMask, appropriateForURL: nil, create: true)
        return documentsUrl
    }
    
    fileprivate func templateRootDirectoryUrl() throws -> URL {
        let documentRootUrl = try self.documentRootDirectoryUrl()
        let templateUrl = documentRootUrl.appendingPathComponent(MemoryCardStorage.storageDirectory)
        
        // Create directory if not exists
        try self.fileManager.createDirectoryAtURL(templateUrl, withIntermediateDirectories: true, attributes: nil)
        return templateUrl
    }
    
    fileprivate func moveFileFromPath(_ fromAbsolutePath: String, toAbsolutePath: String, replace: Bool) throws
    {
        // Replace
        if replace && self.fileManager.fileExistsAtPath(toAbsolutePath) {
            try self.fileManager.removeItemAtPath(toAbsolutePath)
        }
        try self.fileManager.moveItemAtPath(fromAbsolutePath, toPath: toAbsolutePath)
    }
}
