//
//  GameEngineProtocol.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import UIKit

protocol GameEngineProtocol {
    func isTicTacToe(cells: [UICellButton], cellState: EnumCellState) -> Bool
    func isDrawConditionForBoard() -> Bool
    func isDrawConditionForRow(_ row: [UICellButton], player: EnumCellState, opponent: EnumCellState) -> Bool
    func incrementMovesPlayed()
}
