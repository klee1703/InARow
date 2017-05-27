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
    var enableSoundEffects = true
    var enableGameCenter = true
    
    // Properties
    var board: EnumGameBoard = .TTBoard
    var gamePlayMode: EnumPlayMode = .SinglePlayer
    var gameFirstMove: EnumFirstMove = .Me    
    var difficulty: EnumLevelOfDifficulty = .Easy
    
    // Pet property
    var yourPet = "Cat"
}
