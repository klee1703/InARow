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
    
    // Properties
    var board: EnumGameBoard
    var gamePlayMode: EnumPlayMode
    var gameFirstMove: EnumFirstMove
    var difficulty: EnumLevelOfDifficulty
    
    // Pet property
    var yourPet: String
    
    init() {
        enableSoundEffects = true
        enableGameCenter = true
        
        board = .TTBoard
        gamePlayMode = .SinglePlayer
        gameFirstMove = .Me
        difficulty = .Easy
        
        yourPet = "Cat"
    }
}
