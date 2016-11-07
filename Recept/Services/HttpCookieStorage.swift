//
//  HttpCookieStorage.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol HttpCookieStorage {
    func setCookie(_ cookie: HTTPCookie)
    func deleteCookie(_ cookie: HTTPCookie)
    var cookies: [HTTPCookie] { get }
}
