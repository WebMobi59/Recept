//
//  SandboxedCookieStorage.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class SandboxedCookieStorage: NSObject, CookieStorage {
    fileprivate let httpCookieStorage: HttpCookieStorage
    fileprivate let consideredSafeToSaveCookies = ["favoritePharmacy"]
    fileprivate let persistedCookiesKey = "se.apoteket.recept.cookies"
    
    required public init(httpCookieStorage: HttpCookieStorage) {
        self.httpCookieStorage = httpCookieStorage
    }
    
    open func clearAllCookiesExceptThoseConsideredSafe() {
        for cookie in self.httpCookieStorage.cookies {
            if !self.isConsideredSafeCookie(cookie) {
                self.httpCookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    fileprivate func isConsideredSafeCookie(_ cookie: HTTPCookie) -> Bool {
        return self.consideredSafeToSaveCookies.contains(cookie.name)
    }
    
    open func setLoginRedirectCookie(_ returnUrl: String) {
        // Set redirect cookie to apoteket domain
        let cookieProperties = [
            HTTPCookiePropertyKey.domain: ".apoteket.se",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "ApoRedirectOnLogin",
            HTTPCookiePropertyKey.value: returnUrl,
            HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 2629743)
        ] as [HTTPCookiePropertyKey : Any]
        let cookie = HTTPCookie(properties: cookieProperties)!
        
        self.httpCookieStorage.setCookie(cookie)
    }
    
    open func setApoteketDomainCookie(_ name: String, value: String, timeToLiveSeconds: TimeInterval, path: String) {
        let cookieProperties = [
            HTTPCookiePropertyKey.domain: ".apoteket.se",
            HTTPCookiePropertyKey.path: path,
            HTTPCookiePropertyKey.name: name,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: timeToLiveSeconds)
        ] as [HTTPCookiePropertyKey : Any]
        let cookie = HTTPCookie(properties: cookieProperties)!
        
        self.addOrUpdateCookie(cookie)
    }
    
    fileprivate func addOrUpdateCookie(_ cookie: HTTPCookie) {
        let existingCookies = self.findCookiesWithName(cookie.name)
        self.deleteCookies(existingCookies)
        self.httpCookieStorage.setCookie(cookie)
    }
    
    fileprivate func findCookiesWithName(_ name: String) -> [HTTPCookie] {
        return self.httpCookieStorage.cookies.filter { $0.name == name }
    }
    
    fileprivate func deleteCookies(_ cookies: [HTTPCookie]) {
        cookies.forEach { (cookie) -> () in
            self.httpCookieStorage.deleteCookie(cookie)
        }
    }
}
