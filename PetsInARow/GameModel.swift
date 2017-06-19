//
//  GameModel.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameModel {
    // Constants
    let startGame: String = "Let's Begin"
    let winLabel: String = "Tic-Tac-Toe,You Win!"
    let lossLabel: String = "Too bad, better luck next time"

    // Variables
    var computerPet: String
    var playState: EnumPlayState
    var board: [UICellButton]?
    var playLabel: UIImageView?
    var resultsLabel: UILabel?
    
    init() {
        computerPet = "computer"
        playState = .PlayerTurn
    }
}
