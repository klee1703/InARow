//
//  GameModel.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import GameKit

class GameModel {
    // Variables
    var computerPet: String
    var playState: EnumPlayState
    var board: [UICellButton]?
    var playLabel: UIImageView?
    var resultsLabel: UILabel?
    var match: GKMatch?
    var player: GKPlayer?
    var isGameInPlay: Bool
    
    init() {
        computerPet = "computer"
        playState = .PlayerTurn
        isGameInPlay = false
    }
}
