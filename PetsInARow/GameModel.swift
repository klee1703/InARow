//
//  GameModel.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameModel {
    var computerPet: String
    var playState: EnumPlayState
    var board: [UICellButton]?
    var playLabel: UIImageView?
    
    init() {
        computerPet = "computer"
        playState = .PlayerTurn
    }
}
