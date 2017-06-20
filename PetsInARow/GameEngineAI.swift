//
//  GameEngineAI.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/19/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class GameEngineAI {
    // Constants
    let kMaxMoves      = 9
    let kBoardCells    = 9
    let kEvaluateMax   = 30
    let kArc4RandomMax = 0x100000000

    // Variables
    var movesPlayed = 0
    var isFirstCounterMove = false
    var isPlayerWith2Marks = false
    var isComputerWith2Marks = false
    var playerFactor = 3
    var computerFactor = 3
    var winningRow: EnumWinningRow = .None
    var boardGrid: [UICellButton] = []
    
    init(boardGrid: [UICellButton]) {
        // Initialize variables
        self.boardGrid = boardGrid
    }
    
    func isNumberLessThan(wins: UInt32) -> Bool {
        let randomNumber = arc4random_uniform(UInt32(10))
        return randomNumber <= wins
    }

    func isNumberLessThan(difficulty: EnumLevelOfDifficulty) -> Bool {
        let randomNumber = arc4random_uniform(UInt32(10))
        switch difficulty {
        case .Easy:
            return randomNumber <= 3
        case .Medium:
            return randomNumber <= 6
        case .Hard:
            return randomNumber <= 8
        }
    }
    
    func isNumberLessThan(wins: UInt32, orDifficulty: EnumLevelOfDifficulty) -> Bool {
        return isNumberLessThan(wins: wins) || isNumberLessThan(difficulty: orDifficulty)
    }
    
    func getRandomFraction() -> Double {
        return Double(arc4random_uniform(UInt32.max) / UInt32(kArc4RandomMax))
    }

    func makeRandomCounterMove() {
        let cell = Int((getRandomFraction() * 10.0)) % kBoardCells
        if boardGrid[cell].cellState == .None {
            boardGrid[cell].cellState = .Opponent
        } else {
            makeRandomCounterMove()
        }
    }
    
    // Mark empty cell on board grid
    func markBoardCell(settings: SettingsModel, statistics: StatisticsModel) {
        // Initialize
        var bestValue = -kEvaluateMax
        var bestPositionPlayer = 0
        var bestPositionOpponent = 0

        // Compute player factor
        if settings.gameFirstMove == .Player {
            if settings.difficulty == EnumLevelOfDifficulty.Easy {
                //
                if isNumberLessThan(wins: UInt32(statistics.singlePlayerEasyWins)) {
                    self.playerFactor = 7
                }
            } else {
                //
                if isFirstCounterMove && isNumberLessThan(difficulty: settings.difficulty) {
                    self.playerFactor = 7
                }
            }
        }
        
        // If this is the first counter move, mark a random cell on the board grid
        if isFirstCounterMove && !isNumberLessThan(difficulty: settings.difficulty) {
            makeRandomCounterMove()
        } else {
            // Mark cell with the best position
        }
    }
    
    //
}
