//
//  Analytics.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-11-09.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol AnalyticsService {
    var clientId: String! { get }
    func sendScreenView(_ title: String)
    func sendEvent(_ category: String, action: String, label: String)
    func sendEvent(_ category: String, action: String, label: String, value: CGFloat)
    /**
     Intended to be called on lifecycle events - E.g. when it enters foreground or goes to background
     */
    func updateAppState(willHaveState state: AnalyticsServiceDispatchState)
}

public enum AnalyticsServiceDispatchState {
    case background
    case foreground
    case terminated
}
