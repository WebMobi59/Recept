//
//  SystemFileManager.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

/**
 Wrapper class to be able to mock the NSFileManager
 */
open class NSFileManagerWrapper: NSObject, FileManager {
    // Static fileManager since this manager is just a wrapper intended to be easily mocked
    fileprivate let nsFileManager: Foundation.FileManager = Foundation.FileManager.default
    
    open func URLForDirectory(_ directory: Foundation.FileManager.SearchPathDirectory, inDomain: Foundation.FileManager.SearchPathDomainMask, appropriateForURL: URL?, create: Bool) throws -> URL {
        return try self.nsFileManager.url(for: directory, in: inDomain, appropriateFor: appropriateForURL, create: create)
    }
    
    open func createDirectoryAtURL(_ url: URL, withIntermediateDirectories: Bool, attributes: [String : AnyObject]?) throws {
        try self.nsFileManager.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
    
    open func removeItemAtPath(_ path: String) throws {
        try self.nsFileManager.removeItem(atPath: path)
    }
    
    open func moveItemAtPath(_ srcPath: String, toPath: String) throws {
        try self.nsFileManager.moveItem(atPath: srcPath, toPath: toPath)
    }
    
    open func fileExistsAtPath(_ path: String) -> Bool {
        return self.nsFileManager.fileExists(atPath: path)
    }
    
    open func contentsAtPath(_ path: String) -> Data? {
        return self.nsFileManager.contents(atPath: path)
    }
}
