//
//  GameCenterManager.swift
//  PetsInARow
//
//  Created by Keith Lee on 7/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager: NSObject, GKMatchDelegate, GKMatchmakerViewControllerDelegate {
    static var instance: GameCenterManager?
    var loginAlert: UIAlertController?
    var view: GameViewController?
    var  settings: SettingsModel?
    var isMatchStarted = false
    var isMatchEnded = false
    var isEnabledGameCenter = false
    var currentMatch: GKMatch?
    var achievementsCache: [String:GKAchievement] = [:]
        
    static func INSTANCE(view: GameViewController, settings: SettingsModel) -> GameCenterManager? {
        if nil == instance {
            instance = GameCenterManager(view: view, settings: settings)
        }
        
        return instance
    }

    init(view: GameViewController, settings: SettingsModel) {
        self.view = view
        self.settings = settings
    }

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
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // First dismiss current view controller
        self.currentMatch = match
        
        // Set match started
        self.isMatchStarted = true
        
        // Process data received from opponent - update board state, etc.
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)
        
        // Set match ended
        self.isMatchEnded = true
    }

    // Player connected to/disconnected from match
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        //
        switch state {
        case GKPlayerConnectionState.stateConnected:
            // Handle connected condition
            break
        case GKPlayerConnectionState.stateDisconnected:
            // Handle disconnected condition
            break
        case GKPlayerConnectionState.stateUnknown:
            break
        }
        
        if !self.isMatchStarted && (match.expectedPlayerCount == 0) {
            // Have number of expected players, start match!
            self.isMatchStarted = true
            
            // Perform match negotiation
        }
    }
    
    // Matchmaking has failed - can't connect to other players; an error is supplied
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)
        
            let loginError = UIAlertController(title: Constants.kGCMatchmakingFailureErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
            loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
            self.view?.present(loginError, animated: true, completion: nil)
        
    }

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        // Dismiss view controller
        viewController.dismiss(animated: true, completion: nil)
        
        // Set current match accordingly
        self.currentMatch = match
        
    }
    
    // Authenticate player for Game Center functionality (achievements, leaderboards, multi-player)
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
/*            if achievementsCache == nil {
                GKAchievement.loadAchievements(completionHandler: { (achievements, error) -> Void in
                    if error != nil {
                        var tempCache: [String:GKAchievement] = [:]
                        for var achievement in achievements! {
                            tempCache[achievement.identifier!] = achievement
                        }
                        self.achievementsCache = tempCache
                        self.submitAchievement(identifier: identifier, percentComplete: percentComplete)
                    } else {
                        // Set error accordingly
                        if let err = error {
                            let loginError = UIAlertController(title: Constants.kGCSubmitAchievementErrorTitle, message: err.localizedDescription, preferredStyle: .alert)
                            loginError.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                            self.view?.present(loginError, animated: true, completion: nil)
                        }
                    }
                }) */
//            } else {
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
//            }
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
