//
//  GameEngineAI.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/19/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameEngineAI {
    // Constants
    let kMaxMoves      = 9
    let kBoardCells    = 9
    let kEvaluateMax   = 30
    let kGridRows      = 3
    let kGridColumns   = 3

    // Variables
    var movesPlayed = 0
    var isFirstCounterMove = false
    var isPlayerWith2MarksOpponent0Marks = false
    var isOpponenWith2MarksPlayer0Marks = false
    var playerFactor = 3
    var opponentFactor = 3
    var winningElements: EnumWinningElements = .None
    var winningIndex = -1
    var boardGrid = [[UICellButton?]]()
    var settings: SettingsModel
    var statistics: StatisticsModel

    // Initializer
    init(cells: [UICellButton], settings: SettingsModel, statistics: StatisticsModel) {
        // Initialize variables
        self.settings = settings
        self.statistics = statistics
        var index = 0
        boardGrid = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        for row in 0..<kGridRows {
            for column in 0..<kGridColumns {
            boardGrid[row][column] = cells[index]
            index += 1
            }
        }
    }

    // Make a counter move for the opponent
    func makeRandomCounterMove() {
        let rows = Int((GameEngineAI.getRandomFraction() * 10.0)) % kGridRows
        let columns = Int((GameEngineAI.getRandomFraction() * 10.0)) % kGridColumns
        if boardGrid[rows][columns]?.cellState == .none {
            boardGrid[rows][columns]?.cellState = .Opponent
        } else {
            makeRandomCounterMove()
        }
    }

    // Determine if tic-tac-toe achieved
    func isTicTacToe() -> Bool {
        playerFactor = 3
        return evaluatePosition() == kEvaluateMax
    }
    
    // Mark empty cell on board grid
    func markBoardCell(image: UIImage, settings: SettingsModel, statistics: StatisticsModel) {
        // Initialize
        var bestValue = -kEvaluateMax
        var bestRowPosition = 0
        var bestColumnPosition = 0

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
            for row in 0..<kGridRows {
                for column in 0..<kGridColumns {
                    if boardGrid[row][column]?.cellState == EnumCellState.None {
                        // First set the cell to evaluate position
                        boardGrid[row][column]?.cellState = .Opponent
                        
                        // Only attempt to determine best cell to mark if not already marked!
                        let returnedValue = evaluatePosition()
                        if returnedValue >= bestValue {
                            bestValue = returnedValue
                            bestRowPosition = row
                            bestColumnPosition = column
                        }
                        
                        // Then clear the cell (set before evaluating position)
                        boardGrid[row][column]?.cellState = .None
                    }
                }
            }
            
            // Best cell to mark determined, now mark it!
            boardGrid[bestRowPosition][bestColumnPosition]?.cellState = .Opponent
            boardGrid[bestRowPosition][bestColumnPosition]?.setImage(image, for: .normal)
        }
    }

    // Increment number of moves played on the board
    func incrementMovesPlayed() {
        movesPlayed += 1
        
        let isPlayerFirst = settings.gameFirstMove == .Player
        if movesPlayed > 2 {
            isFirstCounterMove = false
        } else {
            if isPlayerFirst && (movesPlayed == 1) {
                isFirstCounterMove = true
            }
        }
    }

    // Reset moves played
    func resetMovesPlayed() {
        movesPlayed = 0
    }
    
    // Return true if the number of moves played exceeds the maximum
    func isMaxMovesPlayed() -> Bool {
        return movesPlayed >= kMaxMoves
    }

    // Reset key board properties
    func resetPlay() {
        movesPlayed = 0
        winningElements = .None
        winningIndex = -1
    }

    // Return true if the game has reached a draw condition.
    // Determined using info for each row/column/diagonal.  If player
    // has 2 marks and opponent has 0 marks (or vice-versa), the logic
    // can determine draws.
    func isDrawCondition() -> Bool {
        let isPlayerFirst = settings.gameFirstMove == .Player
        if movesPlayed < 7 {
            // Draw condition requires at least 7 moves
            return false
        } else if ((movesPlayed == 7) && (isPlayerWith2MarksOpponent0Marks || isOpponenWith2MarksPlayer0Marks)) {
            // Player or opponent with 2 marks, a win is still possible (return false)
            return false
        } else if movesPlayed == 8 {
            if isPlayerFirst && isPlayerWith2MarksOpponent0Marks {
                // Player with 2 marks, a win is still possible!
                return false
            } else if !isPlayerFirst && isOpponenWith2MarksPlayer0Marks {
                // Opponent with 2 marks, a win is still possible!
                return false
            } else {
                // Must be a draw condition, return true
                return true
            }
        } else {
            // Draw condition (board filled with no win), just return true
            return true
        }
    }
    
    /*
     * Evaluate position using MinMax algorithm
     * 3*x2 + x1 - ( 3*O2 + O1 )
     * x2 = number of rows,columns or diagonals with 2 Xs and zero Os
     * x1 = number of rows,columns or diagonals with 1 X and zero Os
     * O2 = number of rows,columns or diagonals with 2 Os and zero Xs
     * O1 = number of rows,columns or diagonals with 1 Os and zero Xs
     *
     * X represents cpu = 1
     * O represents human = 2
     *
     */
    func evaluatePosition() -> Int {
        isPlayerWith2MarksOpponent0Marks = false
        isOpponenWith2MarksPlayer0Marks = false
        var wins: Int
        switch settings.difficulty {
        case .Easy:
            wins = statistics.singlePlayerEasyWins
        case .Medium:
            wins = statistics.singlePlayerMediumWins
        case .Hard:
            wins = statistics.singlePlayerHardWins
        }
        // Set position value
        if getAccumulatedMarksFor(playerMarks: 0, opponentMarks: 3) > 0 {
            return 30
        } else if getAccumulatedMarksFor(playerMarks: 3, opponentMarks: 0) > 0 {
            return 30
        } else if isATrapAt(wins: wins, difficulty: settings.difficulty) {
            return -30
        } else {
            let opponent2Marks = getAccumulatedMarksFor(playerMarks: 0, opponentMarks: 2)
            let opponent1Marks = getAccumulatedMarksFor(playerMarks: 0, opponentMarks: 1)
            let player2Marks = getAccumulatedMarksFor(playerMarks: 2, opponentMarks: 0)
            let player1Marks = getAccumulatedMarksFor(playerMarks: 1, opponentMarks: 0)
            
            // If board indicates x2o0 (pm2) or o2x0 (cm2), set condition
            if (player2Marks > 0) {
                isPlayerWith2MarksOpponent0Marks = true
            }
            if (opponent2Marks > 0) {
                isOpponenWith2MarksPlayer0Marks = true
            }
            
            // Compute and return position value
            return (opponentFactor * opponent2Marks) + opponent1Marks - ((playerFactor * player2Marks) + player1Marks)
        }
    }

    // Return the accumulated number of matching marks on the board
    func getAccumulatedMarksFor(playerMarks: Int, opponentMarks: Int) -> Int {
        var accumulatedMarks = 0
        var tempPlayerMarks = 0
        var tempOpponentMarks = 0

        // Check for winning column
        for row in 0..<kGridRows {
            for column in 0..<kGridColumns {
                if boardGrid[row][column]?.cellState == .Player {
                    tempPlayerMarks += 1
                }
                else if boardGrid[row][column]?.cellState == .Opponent {
                    tempOpponentMarks += 1
                }
            }
            
            if (tempPlayerMarks == playerMarks) && (tempOpponentMarks == opponentMarks) {
                if (tempPlayerMarks == kGridColumns) || (tempOpponentMarks == kGridRows) {
                    winningElements = .Column
                    winningIndex = row
                }
                // Increment accumulated marked squares
                accumulatedMarks += 1
            }
            
            // Reset marks for next row
            tempPlayerMarks = 0
            tempOpponentMarks = 0
        }
        
        // Check for winning row
        tempPlayerMarks = 0
        tempOpponentMarks = 0
        for column in 0..<kGridColumns {
            for row in 0..<kGridRows {
                if boardGrid[row][column]?.cellState == .Player {
                    tempPlayerMarks += 1
                }
                else if boardGrid[row][column]?.cellState == .Opponent {
                    tempOpponentMarks += 1
                }
            }
            
            if (tempPlayerMarks == playerMarks) && (tempOpponentMarks == opponentMarks) {
                if (tempPlayerMarks == kGridColumns) || (tempOpponentMarks == kGridRows) {
                    winningElements = .Row
                    winningIndex = column
                }
                // Increment accumulated marked squares
                accumulatedMarks += 1
            }
            
            // Reset marks for next column
            tempPlayerMarks = 0
            tempOpponentMarks = 0
        }
        
        // Check left-down diagonal
        tempPlayerMarks = 0
        tempOpponentMarks = 0
        for row in 0..<kGridRows {
            if boardGrid[row][row]?.cellState == .Player {
                tempPlayerMarks += 1
            }
            else if boardGrid[row][row]?.cellState == .Opponent {
                tempOpponentMarks += 1
            }
        }
        
        if (tempPlayerMarks == playerMarks) && (tempOpponentMarks == opponentMarks) {
            if (tempPlayerMarks == kGridRows) || (tempOpponentMarks == kGridRows) {
                winningElements = .Diagonal
                winningIndex = 1
            }
            
            // Increment accumulated marked squares
            accumulatedMarks += 1
        }
        
        // Check right-down diagonal
        tempPlayerMarks = 0
        tempOpponentMarks = 0
        for row in 0..<kGridRows {
            if boardGrid[row][kGridRows-1-row]?.cellState == .Player {
                tempPlayerMarks += 1
            }
            else if boardGrid[row][kGridRows-1-row]?.cellState == .Opponent {
                tempOpponentMarks += 1
            }
        }
        
        if (tempPlayerMarks == playerMarks) && (tempOpponentMarks == opponentMarks) {
            if (tempPlayerMarks == kGridRows) || (tempOpponentMarks == kGridRows) {
                winningElements = .Diagonal
                winningIndex = 2
            }
            
            // Increment accumulated marked squares
            accumulatedMarks += 1
        }

        // Return the accumulated number of matching marks on the board
        return accumulatedMarks
    }
    
    // Returns true if a random number is less than input value
    func isRandomNumberLessThan(ceiling: Double) -> Bool {
        return Double(arc4random() / UInt32(Constants.kArc4RandomMax)) < ceiling
    }
    
    // Returns true if a random number is less than input value
    func isRandomNumberYes() -> Bool {
        return Double(arc4random() / UInt32(Constants.kArc4RandomMax)) < 0.7
    }
    
    // Returns true if a random number is less than input value
    func isRandomNumberYes(difficulty: EnumLevelOfDifficulty) -> Bool {
        let randomNumber = Double(arc4random() / UInt32(Constants.kArc4RandomMax))
        switch difficulty {
        case .Easy:
            return randomNumber < 0.8
        case .Medium:
            return randomNumber < 0.9
        case .Hard:
            return randomNumber < 0.95
        }
    }
    
    // Returns true if number is less than the current number of wins for the player
    func isNumberLessThan(wins: UInt) -> Bool {
        return arc4random_uniform(10) < UInt32(wins)
    }
    
    // Return true if the input number is less than a randomly generated number
    func isNumberLessThan(wins: UInt32) -> Bool {
        let randomNumber = arc4random_uniform(UInt32(10))
        return randomNumber <= wins
    }
    
    // Return true if a randomly generated number is less than a number bound by
    // the degree of difficulty for the game
    func isNumberLessThan(difficulty: EnumLevelOfDifficulty) -> Bool {
        let randomNumber = arc4random_uniform(UInt32(10))
        switch difficulty {
        case .Easy:
            return randomNumber <= 5
        case .Medium:
            return randomNumber <= 7
        case .Hard:
            return randomNumber <= 9
        }
    }
    
    // Return true if the a number is less than an input number or a number bound
    // by the degree of difficulty for the game
    func isNumberLessThan(wins: UInt32, difficulty: EnumLevelOfDifficulty) -> Bool {
        return isNumberLessThan(wins: wins) || isNumberLessThan(difficulty: difficulty)
    }
    
    // Return a randomly-generated fraction
    class func getRandomFraction() -> Double {
        return Double(arc4random_uniform(UInt32.max) / UInt32(Constants.kArc4RandomMax))
    }

    /*
     * Logic to address lookahead moves or MinMax algorithm limitations;
     * it checks for traps and notifies the opponent (i.e. computer) if found.
     * This logic assumes that the player makes the first move.
     */
    func isATrapAt(wins: Int, difficulty: EnumLevelOfDifficulty) -> Bool {
        /**
         * Detected trap (1), conditionally return YES
         *    - - X
         *    - O -
         *    X - O
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][2]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Player) &&
            (boardGrid[0][2]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (2), conditionally return YES
         *    O - X
         *    - O -
         *    X - -
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Player) &&
            (boardGrid[0][2]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (3), conditionally return YES
         *    X - O
         *    - O -
         *    - - X
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[0][2]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (4), conditionally return YES
         *    X - -
         *    - O -
         *    O - X
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) &&
            (boardGrid[0][2]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (5), conditionally return YES
         *    X - O
         *    - O -
         *    - X -
         */
        if (boardGrid[0][2]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Player) &&
            (boardGrid[2][1]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][2]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (6), conditionally return YES
         *    - X -
         *    - O -
         *    X - O
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][2]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Player) &&
            (boardGrid[0][1]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[0][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (7), conditionally return YES
         *    - - O
         *    X O -
         *    - - X
         */
        if (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[0][2]!.cellState == .Opponent) &&
            (boardGrid[1][0]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (8), conditionally return YES
         *    - - X
         *    X O -
         *    - - O
         */
        if (boardGrid[2][2]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[0][2]!.cellState == .Player) &&
            (boardGrid[1][0]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (9), conditionally return YES
         *    - - O
         *    - X -
         *    - X O
         */
        if (boardGrid[0][2]!.cellState == .Opponent) &&
            (boardGrid[2][2]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Player) &&
            (boardGrid[2][1]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (10), conditionally return YES
         *    O - -
         *    - X X
         *    O - -
         */
        if (boardGrid[0][0]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .Player) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[0][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) &&
            (boardGrid[2][2]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (11), conditionally return YES
         *    X O -
         *    - O X
         *    X - O
         */
        if (boardGrid[0][1]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][2]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .Player) &&
            (boardGrid[2][0]!.cellState == .Player) &&
            (boardGrid[0][2]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (12), conditionally return YES
         *    - O X
         *    X O -
         *    O - X
         */
        if (boardGrid[0][1]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][0]!.cellState == .Opponent) &&
            (boardGrid[0][2]!.cellState == .Player) &&
            (boardGrid[1][0]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .Player) &&
            (boardGrid[0][0]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[2][1]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (13), conditionally return YES
         *    X - O
         *    - O X
         *    X O -
         */
        if (boardGrid[0][2]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][1]!.cellState == .Opponent) &&
            (boardGrid[0][0]!.cellState == .Player) &&
            (boardGrid[1][2]!.cellState == .Player) &&
            (boardGrid[2][0]!.cellState == .Player) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[1][0]!.cellState == .None) &&
            (boardGrid[2][2]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        /**
         * Detected trap (14), conditionally return YES
         *    O - X
         *    X O -
         *    - O X
         */
        if (boardGrid[0][0]!.cellState == .Opponent) &&
            (boardGrid[1][1]!.cellState == .Opponent) &&
            (boardGrid[2][1]!.cellState == .Opponent) &&
            (boardGrid[0][2]!.cellState == .Player) &&
            (boardGrid[1][0]!.cellState == .Player) &&
            (boardGrid[2][2]!.cellState == .Player) &&
            (boardGrid[0][1]!.cellState == .None) &&
            (boardGrid[1][2]!.cellState == .None) &&
            (boardGrid[2][0]!.cellState == .None) {
            return isNumberLessThan(wins: UInt32(wins), difficulty: difficulty)
        }
        
        // No more traps found, return true
        return false
    }
}
