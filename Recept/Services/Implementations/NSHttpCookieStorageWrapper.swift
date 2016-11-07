//
//  NSHttpCookieStorageWrapper.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class NSHttpCookieStorageWrapper: NSObject, HttpCookieStorage {
    fileprivate var httpCookieStorage: HTTPCookieStorage!
    
    public override init() {
        super.init()
        
        self.httpCookieStorage = HTTPCookieStorage.shared
        self.httpCookieStorage.cookieAcceptPolicy = .always // Needed for CORS in ajax calls from web
    }
    
    open func setCookie(_ cookie: HTTPCookie) {
        return self.httpCookieStorage.setCookie(cookie)
    }
    
    open func deleteCookie(_ cookie: HTTPCookie) {
        return self.httpCookieStorage.deleteCookie(cookie)
    }
    
    open var cookies: [HTTPCookie] {
        get {
            guard let cookies = self.httpCookieStorage.cookies else {
                return []
            }
            return cookies.filter { $0.isKind(of: HTTPCookie.self) }
        }
    }
}
