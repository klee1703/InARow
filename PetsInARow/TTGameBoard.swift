//
//  TTGameBoard.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/13/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class TTGameBoard : GameBoard {
    var board: [Square]
    
    init() {
        board = [Square]()
        super.init(boardSize: 9)
    }
}
