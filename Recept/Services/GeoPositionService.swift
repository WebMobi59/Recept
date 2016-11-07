//
//  GeoPosition.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-09-11.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol GeoPositionService {
    var updateEvent: Event<GeoCoordinate> { get } // Event to attach to for geo updates
    var errorEvent: Event<NSError> { get } // Event to attach to for receiving error messages
    var latestCoordinate: GeoCoordinate? { get }
    var isStarted: Bool { get }
    
    func start(_ stopAfterSeconds: TimeInterval) // Start updating locations to updateEvent and stop the service after x number of seconds
    func stop() // Manually stops the service
}
