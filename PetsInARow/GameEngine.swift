//
//  GameEngine.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/18/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameEngine {
    // Models
    var settings: SettingsModel
    var statistics: StatisticsModel

    init(settings: SettingsModel, statistics: StatisticsModel) {
        self.settings = settings
        self.statistics = statistics
    }
    
    func isTTTHorizontalMatch(cells: [UICellButton], range: CountableClosedRange<Int>, cellState: EnumCellState) -> Bool {
        // Compare for range and return false if not matched
        for index in range {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    func isTTTStepMatch(cells: [UICellButton], initialValue: Int, max: Int, step: Int, cellState: EnumCellState) -> Bool {
        for index in stride(from: initialValue, to: max+1, by: step) {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    func isTTTValuesMatch(cells: [UICellButton], values: [Int], cellState: EnumCellState) -> Bool {
        for index in values {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    // Animate the buttons
    func animateButtons(cells: [UICellButton], range: CountableClosedRange<Int>) {
        for index in range {
            UIView.animate(withDuration: Constants.kDuration, delay: Constants.kDelay, options: [.repeat, .allowUserInteraction], animations: {
                cells[index].alpha = Constants.kAlpha
            }, completion: nil)
        }
    }
    
    func animateButtons(cells: [UICellButton], initialValue: Int, max: Int, step: Int) {
        for index in stride(from: initialValue, to: max+1, by: step) {
            UIView.animate(withDuration: Constants.kDuration, delay: Constants.kDelay, options: [.repeat, .allowUserInteraction], animations: {
                cells[index].alpha = Constants.kAlpha
            }, completion: nil) 
        }
    }
    
    func animateButtons(cells: [UICellButton], values: [Int]) {
        for index in values {
            UIView.animate(withDuration: Constants.kDuration, delay: Constants.kDelay, options: [.repeat, .allowUserInteraction], animations: {
                cells[index].alpha = Constants.kAlpha
            }, completion: nil)
        }
    }
    
    func addWin(difficulty: EnumLevelOfDifficulty, board: EnumGameBoard, playMode: EnumPlayMode) {
        switch playMode {
        case .SinglePlayer:
            switch difficulty {
            case .Easy:
                statistics.singlePlayerEasyWins += 1
            case .Medium:
                statistics.singlePlayerMediumWins += 1
            case .Hard:
                statistics.singlePlayerHardWins += 1
            }
        case .MultiPlayer:
            switch board {
            case .TTBoard:
                statistics.multiPlayer3x3Wins += 1
            case .FFBoard:
                statistics.multiPlayer4x4Wins += 1                
            }
        }
    }
    
    func addWin(board: EnumGameBoard) {
        switch board {
        case .TTBoard:
            statistics.multiPlayer3x3Wins += 1
        case .FFBoard:
            statistics.multiPlayer4x4Wins += 1
        }
    }
}
