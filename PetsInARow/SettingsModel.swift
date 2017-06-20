//
//  SettingsModel.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class SettingsModel {
    // Properties
    var enableSoundEffects: Bool
    var enableGameCenter: Bool
    var setupGame: Bool
    
    // Properties
    var board: EnumGameBoard
    var gamePlayMode: EnumPlayMode
    var gameFirstMove: EnumFirstMove
    var difficulty: EnumLevelOfDifficulty
    
    // Pet property
    var yourPet: String
    var opponentsPet: String
    
    init() {
        enableSoundEffects = true
        enableGameCenter = true
        setupGame = false
        
        board = .TTBoard
        gamePlayMode = .SinglePlayer
        gameFirstMove = .Player
        difficulty = .Easy
        
        yourPet = "Cat"
        opponentsPet = "Dog"
    }
}
