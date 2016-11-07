//
//  TemplateDownloader.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol TemplateDownloader {
    func getRevision(_ success: ((String) -> Void)!, failure: ((NSError?) -> Void)!)
    func getAndSaveTemplateZip(_ toFileName: String!, progress: ((_ percentDownloaded: CGFloat) -> Void)?, success: (() -> Void)!, failure: ((NSError?) -> Void)!)
}
