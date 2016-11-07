//
//  Storage.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol Storage {
    func storageUrl() throws -> URL
    func readDataFromFile(_ pathRelativeToRoot: String) throws -> Data?
    func move(_ fromAbsolutePath: String, toPathRelativeToStorageRootDirectory: String, removeExistingFiles: Bool) throws
}
