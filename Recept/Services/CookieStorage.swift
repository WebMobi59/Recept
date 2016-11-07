//
//  CookieStorage.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol CookieStorage {
    func clearAllCookiesExceptThoseConsideredSafe()
    func setApoteketDomainCookie(_ name: String, value: String, timeToLiveSeconds: TimeInterval, path: String)
    func setLoginRedirectCookie(_ returnUrl: String)
}
