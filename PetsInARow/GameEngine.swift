//
//  GameEngine.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/18/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import GameKit

class GameEngine {
    // Models
    var settings: SettingsModel
    var statistics: StatisticsModel
    var movesPlayed = 0

    init(movesPlayed: Int, settings: SettingsModel, statistics: StatisticsModel) {
        self.settings = settings
        self.statistics = statistics
        self.movesPlayed = movesPlayed
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
                GameCenterManager.instance?.submitAchievement(identifier: "spWinsEasy", percentComplete: Double(statistics.singlePlayerEasyWins) * 10.0)
            case .Medium:
                statistics.singlePlayerMediumWins += 1
                GameCenterManager.instance?.submitAchievement(identifier: "spWinsMedium", percentComplete: Double(statistics.singlePlayerMediumWins) * 10.0)
            case .Hard:
                statistics.singlePlayerHardWins += 1
                GameCenterManager.instance?.submitAchievement(identifier: "spWinsHard", percentComplete: Double(statistics.singlePlayerHardWins) * 10.0)
            }
        case .MultiPlayer:
            switch board {
            case .TTBoard:
                statistics.multiPlayer3x3Wins += 1
                GameCenterManager.instance?.submitAchievement(identifier: "mpWins3x3", percentComplete: Double(statistics.multiPlayer3x3Wins) * 10.0)
            case .FFBoard:
                statistics.multiPlayer4x4Wins += 1                
                GameCenterManager.instance?.submitAchievement(identifier: "mpWins4x4", percentComplete: Double(statistics.multiPlayer4x4Wins) * 10.0)
            }
        }
    }
    
    func addWin(board: EnumGameBoard) {
        switch board {
        case .TTBoard:
            statistics.multiPlayer3x3Wins += 1
            GameCenterManager.instance?.submitAchievement(identifier: "mpWins3x3", percentComplete: Double(statistics.multiPlayer3x3Wins) * 10.0)
        case .FFBoard:
            statistics.multiPlayer4x4Wins += 1
            GameCenterManager.instance?.submitAchievement(identifier: "mpWins4x4", percentComplete: Double(statistics.multiPlayer4x4Wins) * 10.0)
        }
    }
    
    func isDrawConditionForRow(_ row: [UICellButton], player: EnumCellState, opponent: EnumCellState) -> Bool {
        var cellStates: [EnumCellState] = []
        for index in 0..<row.count {
            cellStates.insert(row[index].cellState, at: index)
        }
        
        if cellStates.contains(player) && cellStates.contains(opponent) {
            return true
        } else {
            return false
        }
    }
    
    func incrementMovesPlayed() {
        self.movesPlayed += 1
    }
}
