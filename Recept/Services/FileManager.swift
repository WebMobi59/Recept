//
//  FileManager.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol FileManager {
    func URLForDirectory(_ directory: Foundation.FileManager.SearchPathDirectory, inDomain: Foundation.FileManager.SearchPathDomainMask, appropriateForURL: URL?, create: Bool) throws -> URL
    
    func createDirectoryAtURL(_ url: URL, withIntermediateDirectories: Bool, attributes: [String : AnyObject]?) throws
    
    func removeItemAtPath(_ path: String) throws
    func moveItemAtPath(_ srcPath: String, toPath: String) throws
    func fileExistsAtPath(_ path: String) -> Bool
    func contentsAtPath(_ path: String) -> Data?
}
