//
//  GameEngine44.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class GameEngine44: GameEngine, GameEngineProtocol {
    override init(settings: SettingsModel, statistics: StatisticsModel) {
        super.init(settings: settings, statistics: statistics)
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
}
