//
//  ArrayExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-09.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension Array {
    func contains<T>(_ obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
