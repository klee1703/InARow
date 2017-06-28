//
//  AudioManager.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/27/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class AudioManager {
    var playerMark: AVAudioPlayer?
    var opponentMark: AVAudioPlayer?
    var playerWin: AVAudioPlayer?
    var opponentWin: AVAudioPlayer?
    var draw: AVAudioPlayer?
    
    static var instance: AudioManager?
    
    init() {
        let playerMarkUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.kPlayerMarkSound, ofType: "wav")!)
        do {
            try playerMark = AVAudioPlayer(contentsOf: playerMarkUrl)
        } catch {
            print("Error loading resource")
        }
        
        let playerWinUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.kPlayerWinSound, ofType: "wav")!)
        do {
            try playerWin = AVAudioPlayer(contentsOf: playerWinUrl)
        } catch {
            print("Error loading resource")
        }
        
        let opponentMarkUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.kOpponentMarkSound, ofType: "wav")!)
        do {
            try opponentMark = AVAudioPlayer(contentsOf: opponentMarkUrl)
        } catch {
            print("Error loading resource")
        }
        
        let opponentWinUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.kOpponentWinSound, ofType: "wav")!)
        do {
            try opponentWin = AVAudioPlayer(contentsOf: opponentWinUrl)
        } catch {
            print("Error loading resource")
        }
        
        let drawUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.kDrawSound, ofType: "wav")!)
        do {
            try draw = AVAudioPlayer(contentsOf: drawUrl)
        } catch {
            print("Error loading resource")
        }
    }
    
    static func INSTANCE() -> AudioManager? {
        if nil == instance {
            instance = AudioManager()
        }
        
        return instance
    }
}
