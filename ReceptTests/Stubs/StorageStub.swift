//
//  MoveableStorageStub.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Recept_UnitTests
class StorageStub: NSObject, Storage {
    func storageUrl() throws -> NSURL {
        fatalError("storageUrl has not been implemented")
    }
    
    func readDataFromFile(pathRelativeToRoot: String) throws -> NSData? {
        fatalError("readDataFromFile has not been implemented")
    }
    
    func move(fromAbsolutePath: String, toPathRelativeToStorageRootDirectory: String, removeExistingFiles: Bool) throws {
        fatalError("move has not been implemented")
    }
}