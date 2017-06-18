//
//  SecondViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/5/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    var tbvc: GameTabBarController?
    // Model data for settings
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?

    @IBOutlet weak var spEasyWins: UILabel!
    @IBOutlet weak var spMediumWins: UILabel!
    @IBOutlet weak var spHardWins: UILabel!

    @IBOutlet weak var multi33Wins: UILabel!
    @IBOutlet weak var multi44Wins: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        // Persist statistics
        PersistenceManager.archive(model: statisticsModel, filePath: StatisticsModel.filePath(), key: StatisticsModel.kStatisticsKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        statisticsModel = tbvc!.statistics
        gameModel = tbvc!.game
        spEasyWins.text = "\(statisticsModel!.singlePlayerEasyWins)"
        spMediumWins.text = "\(statisticsModel!.singlePlayerMediumWins)"
        spHardWins.text = "\(statisticsModel!.singlePlayerHardWins)"
        
        multi33Wins.text = "\(statisticsModel!.multiPlayer3x3Wins)"
        multi44Wins.text = "\(statisticsModel!.multiPlayer4x4Wins)"
    }

    @IBAction func resetSpEasyWins(_ sender: UIButton) {
        statisticsModel!.singlePlayerEasyWins = 0
        self.viewWillAppear(true)
    }

    @IBAction func resetSpMediumWins(_ sender: UIButton) {
        statisticsModel!.singlePlayerMediumWins = 0
        self.viewWillAppear(true)
    }
    
    @IBAction func resetSpHardWins(_ sender: UIButton) {
        statisticsModel!.singlePlayerHardWins = 0
        self.viewWillAppear(true)
    }

    @IBAction func resetMp33Wins(_ sender: UIButton) {
        statisticsModel!.multiPlayer3x3Wins = 0
        self.viewWillAppear(true)
    }

    @IBAction func resetMp44Wins(_ sender: UIButton) {
        statisticsModel!.multiPlayer4x4Wins = 0
        self.viewWillAppear(true)
    }
    
}

