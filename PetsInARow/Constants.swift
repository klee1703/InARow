//
//  Constants.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/23/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

struct Constants {
    static let kArc4RandomMax = 0x100000000
    static let kComputerImageFile = "Computer.png"

    // Game label text
    static let kStartGameLabel = "Let's Begin"
    static let kPlayerWinLabel = "Tic-Tac-Toe,You Win!"
    static let kComputerWinLabel = "The Computer Wins, Oh No!"
    static let kOpponentWinLabel = "Your Opponent Wins, Oh No!"
    static let kDrawLabel = "Draw, try again?"

    // Segues for game boards
    static let k3x3BoardSegue = "Board33Segue"
    static let k4x4BoardSegue = "Board44Segue"

    // Alert messages
    static let kGameCenterMessage = "Are you sure you want to enable/disable Game Center and begin a new game?"
    static let kGameBoardMessage = "Are you sure you want to update the Game Board and begin a new game?"
    static let kPlayModeMessage = "Are you sure you want to update the Play Mode and begin a new game?"
    static let kLevelOfDifficultyMessage = "Are you sure you want to update the Level-of-Difficulty and begin a new game?"

    // Game Engine Constants
    static let kDuration = 0.8
    static let kDelay = 0.0
    // Alpha must be > 0.01, otherwise user interaction will be disabled when animation ends!
    static let kAlpha: CGFloat = 0.02
    
    // Audio file constants
    static let kPlayerMarkSound = "BrassPlate1"
    static let kOpponentMarkSound = "GlassPlate1"
    static let kOpponentWinSound = "oh_no"
    static let kPlayerWinSound = "clapping"
    static let kDrawSound = "boing"
    
    // Max moves on board grid
    static let kMaxMoves3x3 = 9
    static let kMaxMoves4x4 = 16

    // Game Center Messages
    static let kGCLoginRequiredTitle = "Login Required for Game Center Access"
    static let kGCLoginRequiredMessage = "Please Login to Enable Game Center Functionality"
    static let kGCLoginErrorTitle = "Error Logging in for Game Center Access"
    static let kGCResetAchievementsErrorTitle = "Error resetting achievements"
    static let kGCReportAchievementsErrorTitle = "Error reporting achievements"
    static let kGCSubmitAchievementErrorTitle = "Error submitting achievements"
    static let kGCReportAchievementErrorTitle = "Error reporting achievements"

}
