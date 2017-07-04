//
//  StatisticsModel.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class StatisticsModel: NSObject, NSCoding {
    // Keys for encoding/decoding
    let kSinglePlayerEasyWins = "SinglePlayerEasyWins"
    let kSinglePlayerMediumWins = "SinglePlayerMediumWins"
    let kSinglePlayerHardWins = "SinglePlayerHardWins"
    
    let kMultiPlayer3x3Wins = "MultiPlayer3x3Wins"
    let kMultiPlayer4x4Wins = "MultiPlayer4x4Wins"

    static let kStatisticsKey = "Statistics.key"
    static let kStatisticsFilePath = "Statistics.archive"
    
    // Single player wins
    var singlePlayerEasyWins: Int
    var singlePlayerMediumWins: Int
    var singlePlayerHardWins: Int

    // MultiPlayer wins
    var multiPlayer3x3Wins: Int
    var multiPlayer4x4Wins: Int
    
    override init() {
        singlePlayerEasyWins = 0
        singlePlayerMediumWins = 0
        singlePlayerHardWins = 0
        
        // MultiPlayer wins
        multiPlayer3x3Wins = 0
        multiPlayer4x4Wins = 0
    }

    // NSCoder methods
    required init?(coder aDecoder: NSCoder) {
        singlePlayerEasyWins = Int(aDecoder.decodeInt64(forKey: kSinglePlayerEasyWins))
        singlePlayerMediumWins = Int(aDecoder.decodeInt64(forKey: kSinglePlayerMediumWins))
        singlePlayerHardWins = Int(aDecoder.decodeInt64(forKey: kSinglePlayerHardWins))
        
        multiPlayer3x3Wins = Int(aDecoder.decodeInt64(forKey: kMultiPlayer3x3Wins))
        multiPlayer4x4Wins = Int(aDecoder.decodeInt64(forKey: kMultiPlayer4x4Wins))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.singlePlayerEasyWins, forKey: kSinglePlayerEasyWins)
        aCoder.encode(self.singlePlayerMediumWins, forKey: kSinglePlayerMediumWins)
        aCoder.encode(self.singlePlayerHardWins, forKey: kSinglePlayerHardWins)
        
        aCoder.encode(self.multiPlayer3x3Wins, forKey: kMultiPlayer3x3Wins)
        aCoder.encode(self.multiPlayer4x4Wins, forKey: kMultiPlayer4x4Wins)
    }

    static func filePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let url = NSURL(fileURLWithPath: documentsDirectory)
        let filePath = url.appendingPathComponent(kStatisticsFilePath)
        return (filePath?.path)!
    }
    
    func update(_ model: StatisticsModel) {
        self.singlePlayerEasyWins = model.singlePlayerEasyWins
        self.singlePlayerMediumWins = model.singlePlayerMediumWins
        self.singlePlayerHardWins = model.singlePlayerHardWins
        
        self.multiPlayer3x3Wins = model.multiPlayer3x3Wins
        self.multiPlayer4x4Wins = model.multiPlayer4x4Wins
    }
}
