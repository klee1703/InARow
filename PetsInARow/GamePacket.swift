//
//  GamePacket.swift
//  PetsInARow
//
//  Created by Keith Lee on 7/24/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import UIKit

class GamePacket {
    var playerCellIndex: Int
    var playerImageFileName: String
    var opponentImageFileName: String
    var gameBoard: EnumGameBoard
    var isPlayerMove: Bool
    
    init(playerMove: Bool, cellIndex: Int, playermageFileName: String, opponentImageFileName: String, gameBoard: EnumGameBoard) {
        self.isPlayerMove = playerMove
        self.playerCellIndex = cellIndex
        self.playerImageFileName = playermageFileName
        self.opponentImageFileName = opponentImageFileName
        self.gameBoard = gameBoard
    }
    
}
