//
//  FFGameBoard.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/26/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class FFGameBoard : GameBoard {
    var board: [Square]
    
    init() {
        board = [Square]()
        super.init(boardSize: 16)
    }
}
