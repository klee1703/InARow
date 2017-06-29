//
//  GameEngineProtocol.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

protocol GameEngineProtocol {
    func isTicTacToe(cells: [UICellButton], cellState: EnumCellState) -> Bool
    func isDrawCondition(cells: [UICellButton]) -> Bool
    func incrementMovesPlayed()
}
