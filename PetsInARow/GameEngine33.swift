//
//  GameEngine3x3.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class GameEngine33: GameEngine, GameEngineProtocol, GameAIProtocol {
    func markCell(cells: [UICellButton]) {
        // IMPLEMENT!
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
}
