//
//  GameCenterManager.swift
//  PetsInARow
//
//  Created by Keith Lee on 7/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager {    
    static var instance: GameCenterManager?
    var loginAlert: UIAlertController?
    var view: GameViewController?
    var  settings: SettingsModel?
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
    
    // Authenticate player for Game Center functionality (achievements, leaderboards, multi-player)
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if !localPlayer.isAuthenticated {
            localPlayer.authenticateHandler = { (loginAlert, error) -> Void in
                if localPlayer.isAuthenticated {
                    self.view?.displayName = localPlayer.displayName!
                    self.initializeGameCenter(player: localPlayer)
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
