//
//  WebNativeBridge.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-25.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol WebNativeBridge {
    func isNativeUrl(_ url: URL) -> Bool
    func handleNativeUrl(_ url: URL, fromWebView: UIWebView?) throws
}
