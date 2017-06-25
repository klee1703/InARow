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
    
    init(cells: [UICellButton], settings: SettingsModel, statistics: StatisticsModel) {
        super.init(settings: settings, statistics: statistics)
        
        self.cells = cells
        gameEngineAI = GameEngineAI(cells: cells, settings: settings, statistics: statistics)
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
}
