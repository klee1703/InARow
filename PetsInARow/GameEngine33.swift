//
//  GameEngine3x3.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameEngine33: GameEngine, GameEngineProtocol, GameAIProtocol {
    var cells: [UICellButton]?
    var gameEngineAI: GameEngineAI?
    var rows: [Int:[UICellButton]] = [:]
    
    init(movesPlayed: Int, cells: [UICellButton], settings: SettingsModel, statistics: StatisticsModel) {
        self.cells = cells
        gameEngineAI = GameEngineAI(cells: cells, settings: settings, statistics: statistics)
        super.init(movesPlayed: movesPlayed, settings: settings, statistics: statistics)
        rows = initializeRows(cells: self.cells!)
    }
    
    func markCell(image: UIImage) {
        // Mark grid board cell using AI engine
        gameEngineAI?.markBoardCell(image: image)
    }
    
    func isTicTacToe(cells: [UICellButton], cellState: EnumCellState) -> Bool {
        // Check for horizontal match
        if isTTTHorizontalMatch(cells: cells, range: 0...2, cellState: cellState) {
            animateButtons(cells: cells, range: 0...2)
            return true
        }
        if isTTTHorizontalMatch(cells: cells, range: 3...5, cellState: cellState) {
            animateButtons(cells: cells, range: 3...5)
            return true
        }
        
        if isTTTHorizontalMatch(cells: cells, range: 6...8, cellState: cellState) {
            animateButtons(cells: cells, range: 6...8)
            return true
        }
        
        // Check for vertical match
        if isTTTStepMatch(cells: cells, initialValue: 0, max: 6, step: 3, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 0, max: 6, step: 3)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 1, max: 7, step: 3, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 1, max: 7, step: 3)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 2, max: 8, step: 3, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 2, max: 8, step: 3)
            return true
        }
        
        // Check for diagonal match
        if isTTTStepMatch(cells: cells, initialValue: 0, max: 8, step: 4, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 0, max: 8, step: 4)
            return true
        }
        
        if isTTTStepMatch(cells: cells, initialValue: 2, max: 6, step: 2, cellState: cellState) {
            animateButtons(cells: cells, initialValue: 2, max: 6, step: 2)
            return true
        }
        
        // No match found on board, return false
        return false
    }
    
    func isDrawConditionForBoard() -> Bool {
        var isDraw = true
        
        // If all moves made then draw condition by definitionui
        if movesPlayed == rows.count {
            isDraw = true
        } else {
            for row in 0..<rows.count {
                // Check all rows
                if !isDrawConditionForRow(rows[row]!, player: EnumCellState.Player, opponent: EnumCellState.Opponent) {
                    // Not a draw condition, only need one row in this condition, set to 
                    // false and exit loop
                    isDraw = false
                    break
                }
            }
        }
        return isDraw
    }
    
    func initializeRows(cells: [UICellButton]) -> [Int:[UICellButton]] {
        var temp: [Int:[UICellButton]] = [:]
        temp[0] = [cells[0], cells[1], cells[2]]
        temp[1] = [cells[3], cells[4], cells[5]]
        temp[2] = [cells[6], cells[7], cells[8]]
        temp[3] = [cells[0], cells[3], cells[6]]
        temp[4] = [cells[1], cells[4], cells[7]]
        temp[5] = [cells[2], cells[5], cells[8]]
        temp[6] = [cells[0], cells[4], cells[8]]
        temp[7] = [cells[2], cells[4], cells[6]]
        
        return temp
    }
}
