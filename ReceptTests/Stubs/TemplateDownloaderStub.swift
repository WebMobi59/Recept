//
//  TemplateDownloaderStub.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-20.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Recept_UnitTests
class TemplateDownloaderStub: NSObject, TemplateDownloader {
    func getRevision(success: ((String) -> Void)!, failure: ((NSError!) -> Void)!) {
        fatalError("getRevision has not been implemented")
    }
    
    func getAndSaveTemplateZip(toFileName: String!, progress: ((percentDownloaded: CGFloat) -> Void)?, success: (() -> Void)!, failure: ((NSError!) -> Void)!) {
        fatalError("getAndSaveTemplateZip has not been implemented")
    }
}