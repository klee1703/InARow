//
//  GameCenterManager.swift
//  PetsInARow
//
//  Created by Keith Lee on 7/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import GameKit

/**
 * API that provides game center functionality
 */
class GameCenterManager: NSObject, GKMatchDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener {
    static var instance: GameCenterManager?
    var loginAlert: UIAlertController?
    var view: GameViewController?
    var  settings: SettingsModel?
    var game: GameModel?
    var isMatchStarted = false
    var isMatchEnded = false
    var isEnabledGameCenter = false
    var currentMatch: GKMatch?
    var achievementsCache: [String:GKAchievement] = [:]

    /**
     * Retrieve a shared (global) GameCenterManager instance
     */
    static func INSTANCE(view: GameViewController, settings: SettingsModel, game: GameModel) -> GameCenterManager? {
        if nil == instance {
            instance = GameCenterManager(view: view, settings: settings, game: game)
        }
        
        return instance
    }

    /**
     * Constructor for initializing the GameCenterManager
     */
    init(view: GameViewController, settings: SettingsModel, game: GameModel) {
        self.view = view
        self.settings = settings
        self.game = game
    }

    /**
     * GKMatchDelegate methods
     */
    
    // Find a match using real-time matchmaking
    func findMatch(minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate: GKMatchDelegate) {
        if self.isEnabledGameCenter {
            // Create match request for desired number of players
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = minPlayers
            matchRequest.maxPlayers = maxPlayers
            
            // Present matchmaker user interface and set its delegate
            let matchmakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
            matchmakerViewController?.matchmakerDelegate = self
            
            // Then present interface
            viewController.present(matchmakerViewController!, animated: true, completion: nil)
        }
    }

    // Receive and process data
    /**
     * Method that processes received match data
     */
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // First dismiss current view controller
        self.currentMatch = match
        
        // Set match started
        self.isMatchStarted = true
        
        // Process data received from opponent - update board state, etc.
        view?.gbcvc?.gbvc?.receive(match: match, data: data, remotePlayer: player)
    }

    /**
     * GKMatchmakerViewControllerDelegate methods
     */
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)
        
        // Set match ended
        self.isMatchEnded = true
    }

    // Player connected to/disconnected from match
    /**
     * Method that performs processing when a player connects/disconnects to/from a game
     */
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        //
        switch state {
        case GKPlayerConnectionState.stateConnected:
            // Handle connected condition
            print("Player \(player.alias ?? "Unknown") connected")
            break
        case GKPlayerConnectionState.stateDisconnected:
            // Handle disconnected condition
            print("Player \(player.alias ?? "Unknown") connected")
            break
        case GKPlayerConnectionState.stateUnknown:
            print("Player \(player.alias ?? "Unknown") state unknown")
            break
        }
        
        if !self.isMatchStarted {
            // Have number of expected players, start match!
            self.isMatchStarted = true
            
            // Perform match negotiation
        }
    }
    
    // Matchmaking has failed - can't connect to other players; an error is supplied
    /**
     * Error processing when multi-player game can't connect to other players
     */
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)
        
            let loginError = UIAlertController(title: Constants.kGCMatchmakingFailureErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
            loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
            self.view?.present(loginError, animated: true, completion: nil)
        
    }
    
    // Match found, set GKMatch accordingly
    /**
     * Processing performed when a multi-player match is found
     */
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)

        // Set current match accordingly
        self.currentMatch = match
    }

    /**
     * GKLocalPlayerListener methods
     */
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        
    }
    
    // Authenticate player for Game Center functionality (achievements, leaderboards, multi-player)
    /**
     * Method used to authenticate the local player in game center
     */
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if !localPlayer.isAuthenticated {
            self.isEnabledGameCenter = false
            settings?.enableGameCenter = self.isEnabledGameCenter
            localPlayer.authenticateHandler = { (loginAlert, error) -> Void in
                if localPlayer.isAuthenticated {
                    // Set game center enabled
                    self.isEnabledGameCenter = true
                    self.settings?.enableGameCenter = self.isEnabledGameCenter
                    self.view?.displayName = localPlayer.displayName!
                    
                    // Intialize game center (load achievements, etc.)
                    self.initializeGameCenter(player: localPlayer)
                    
                    // Then find a match
                    if self.settings?.gamePlayMode == EnumPlayMode.MultiPlayer {
                        self.findMatch(minPlayers: Constants.kGCMatchMakingMinPlayers, maxPlayers: Constants.kGCMatchMakingMaxPlayers, viewController: self.view!, delegate: self)
                        }
                }
                else if self.loginAlert != nil {
                    self.view?.present(self.loginAlert!, animated: true, completion: nil)
                } else {
                    if let err = error {
                        let loginError = UIAlertController(title: Constants.kGCLoginErrorTitle, message: err.localizedDescription, preferredStyle: .alert)
                        loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                        self.view?.present(loginError, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Authenticated, find match if in multiplayer mode
            if self.settings?.gamePlayMode == EnumPlayMode.MultiPlayer {
                self.findMatch(minPlayers: Constants.kGCMatchMakingMinPlayers, maxPlayers: Constants.kGCMatchMakingMaxPlayers, viewController: self.view!, delegate: self)
            }
        }
    }
    
    func initializeGameCenter(player: GKLocalPlayer) {
        // Load achievements
        loadAchievements()
    }
    
    func loadAchievements() {
        if (settings?.enableGameCenter)! {
            GKAchievement.loadAchievements(completionHandler: {(achievements, error) -> Void in
                    // Initialize achievements cache appropriately.
                    for achievement in achievements! {
                        self.achievementsCache[achievement.identifier!] = achievement
                    }
            })
        }
    }

    func getAchievement(identfier: String) -> GKAchievement {
        var achievement = self.achievementsCache[identfier]
        if achievement == nil {
            achievement = GKAchievement(identifier: identfier)
            achievementsCache[identfier] = achievement
        }
        
        return achievement!
    }
    
    func submitAchievement(identifier: String, percentComplete: Double) {
        if (settings?.enableGameCenter)! {
            // Search the list for the ID we're using
            var achievement = self.achievementsCache[identifier]
            if achievement != nil {
                if ((achievement?.percentComplete)! >= 100.0) || ((achievement?.percentComplete)! >= percentComplete) {
                    // Achievement has already been already been achieved so we're done
                    achievement = nil
                } else {
                    // Set its percent complete to input argument
                    achievement?.percentComplete = percentComplete
                }
            } else {
                // Achievement not found, create one and set its percent complete
                achievement = GKAchievement(identifier: identifier)
                achievement?.percentComplete = percentComplete
                
                // Then add to the achievement's cache
                achievementsCache[(achievement?.identifier)!] = achievement
            }
            
            // Now submit the achievement
            if achievement != nil {
                GKAchievement.report([achievement!], withCompletionHandler: { (error) -> Void in
                    if error == nil {
                        // Set error accordingly
                        if let err = error {
                            let loginError = UIAlertController(title: Constants.kGCReportAchievementErrorTitle, message: err.localizedDescription, preferredStyle: .alert)
                            loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                            self.view?.present(loginError, animated: true, completion: nil)
                        }
                    }
                })
                
            }
        }
    }
    
    func reportAchievement(identifier: String, percentComplete: Double) {
        if (settings?.enableGameCenter)! {
            let achievement = getAchievement(identfier: identifier)
            if (achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete) {
                // Achievement already earned so we're done.
                return
            } else {
                // Update achievement and cached achievement
                achievement.percentComplete += percentComplete
                achievementsCache[identifier] = achievement
                
                // Report updated achievement to Game Center
                GKAchievement.report([achievement], withCompletionHandler: {(error) -> Void in
                    if let err = error {
                        let loginError = UIAlertController(title: Constants.kGCReportAchievementsErrorTitle, message: err.localizedDescription, preferredStyle: .alert)
                        loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                        self.view?.present(loginError, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func resetAchievements() {
        if (settings?.enableGameCenter)! {
            achievementsCache.removeAll()
            GKAchievement.resetAchievements(completionHandler: {(error) -> Void in
                if let err = error {
                    let loginError = UIAlertController(title: Constants.kGCResetAchievementsErrorTitle, message: err.localizedDescription, preferredStyle: .alert)
                    loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                    self.view?.present(loginError, animated: true, completion: nil)
                }
            })
        }
    }
}
