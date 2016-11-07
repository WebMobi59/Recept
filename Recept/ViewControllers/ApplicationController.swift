//
//  RootViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-08-25.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol ApplicationController {
    func inactivate()
    func activate()
    func handleOpenAppFromUrl(_ url: URL!) -> Bool
    var rootViewController: UIViewController! { get }
}
