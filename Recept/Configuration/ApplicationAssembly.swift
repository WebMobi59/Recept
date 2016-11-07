//
//  ApplicationAssembly.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-18.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

public protocol ApplicationAssembly {
    func applicationController() -> ApplicationController!
    func applicationAnalyticsService() -> AnalyticsService!
    static func assemblyEnvironment() -> AssemblyEnvironment
}

public enum AssemblyEnvironment {
    case unittests
    case debug
    case dev
    case test
    case production // Should be considered as default
}
