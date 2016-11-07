//
//  TemplateStorage.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-01.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol TemplateRepository {
    var entryUrl: URL { get set }
    var loggedOutUrl: URL { get set }
    var basketUrl: URL { get set }
    var menuUrlUnauthorized: URL { get set }
    var menuUrlAuthorized: URL { get set }
    var isLoaded: Bool { get set }
    func load(_ progress: @escaping (CGFloat) -> Void, completion: @escaping (_ isUpdated: Bool, _ error: NSError?) -> Void)
    func isMenuUrl(_ url: URL) -> Bool
}
