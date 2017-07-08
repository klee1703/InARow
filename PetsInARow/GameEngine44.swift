//
//  GameEngine44.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class GameEngine44: GameEngine, GameEngineProtocol {
    var cells: [UICellButton]?
    var rows: [Int:[UICellButton]] = [:]
    
    override init(movesPlayed: Int, settings: SettingsModel, statistics: StatisticsModel) {
        super.init(movesPlayed: movesPlayed, settings: settings, statistics: statistics)
        rows = initializeRows(cells: self.cells!)
    }
    
    func isTicTacToe(cells: [UICellButton], cellState: EnumCellState) -> Bool {
        // Check for horizontal match
        if isTTTHorizontalMatch(cells: cells, range: 0...3, cellState: cellState) {
            animateButtons(cells: cells, range: 0...3)
            return true
        }
        if isTTTHorizontalMatch(cells: cells, range: 4...7, cellState: cellState) {
            animateButtons(cells: cells, range: 4...7)
            return true
        }
        
        if isTTTHorizontalMatch(cells: cells, range: 8...11, cellState: cellState) {
            animateButtons(cells: cells, range: 8...11)
            return true
        }
        
        if isTTTHorizontalMatch(cells: cells, range: 12...15, cellState: cellState) {
            animateButtons(cells: cells, range: 12...15)
            return true
        }
        
        // Check for vertical match
        if isTTTStepMatch(cells: cells, initialValue: 0, max: 12, step: 4, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 0, max: 12, step: 4)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 1, max: 13, step: 4, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 1, max: 13, step: 4)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 2, max: 14, step: 4, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 2, max: 14, step: 4)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 3, max: 15, step: 4, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 3, max: 15, step: 4)
            return true
        }
        
        // Check for diagonal match
        if isTTTStepMatch(cells: cells, initialValue: 0, max: 15, step: 5, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 0, max: 15, step: 5)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 3, max: 12, step: 3, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 3, max: 12, step: 3)
            return true
        }
        
        // Check for inner square match
        if isTTTValuesMatch(cells: cells, values: [5, 6, 9, 10], cellState: cellState) {
            animateButtons(cells: cells, values: [5, 6, 9, 10])
            return true
        }
        
        // Check for outer corners match
        if isTTTValuesMatch(cells: cells, values: [0, 3, 12, 15], cellState: cellState) {
            animateButtons(cells: cells, values: [0, 3, 12, 15])
            return true
        }
        
        // No match found on board, return false
        return false
    }
    
    func initializeRows(cells: [UICellButton]) -> [Int:[UICellButton]] {
        var temp: [Int:[UICellButton]] = [:]
        temp[0] = [cells[0], cells[1], cells[2], cells[3]]
        temp[1] = [cells[4], cells[5], cells[6], cells[7]]
        temp[2] = [cells[8], cells[9], cells[10], cells[11]]
        temp[3] = [cells[12], cells[13], cells[14], cells[15]]
        temp[4] = [cells[0], cells[4], cells[8], cells[12]]
        temp[5] = [cells[1], cells[5], cells[9], cells[13]]
        temp[6] = [cells[1], cells[5], cells[9], cells[13]]
        temp[7] = [cells[1], cells[5], cells[9], cells[13]]
        temp[8] = [cells[0], cells[5], cells[10], cells[15]]
        temp[9] = [cells[3], cells[6], cells[9], cells[12]]
        temp[10] = [cells[5], cells[6], cells[9], cells[10]]
        temp[11] = [cells[0], cells[3], cells[12], cells[15]]
        
        return temp
    }
    
    func isDrawConditionForBoard() -> Bool {
        var isDraw = true
        
        // If all moves made then draw condition by definition
        if movesPlayed == rows.count {
            isDraw = true
        } else {
            for row in 0..<rows.count {
                if !isDrawConditionForRow(rows[row]!, player: EnumCellState.Player, opponent: EnumCellState.Opponent) {
                    isDraw = false
                    break
                }
            }
        }
        return isDraw
    }
}
