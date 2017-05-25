//
//  EnumPlayMode.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/20/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

enum EnumPlayMode: Int {
    case SinglePlayer = 0
    case MultiPlayer = 1

    static func values() -> [Int] {
        return [SinglePlayer.rawValue, MultiPlayer.rawValue]
    }
}
