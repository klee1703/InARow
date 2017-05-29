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
    var gameModel: GameModel?
    var statisticsModel: StatisticsModel?

    @IBOutlet weak var spEasyWins: UILabel!
    @IBOutlet weak var spMediumWins: UILabel!
    @IBOutlet weak var spHardWins: UILabel!

    @IBOutlet weak var multi33Wins: UILabel!
    @IBOutlet weak var multi44Wins: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        statisticsModel = tbvc!.statistics
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        gameModel = tbvc!.game
        spEasyWins.text = "\(statisticsModel!.spEasyWins)"
        spMediumWins.text = "\(statisticsModel!.spMediumWins)"
        spHardWins.text = "\(statisticsModel!.spHardWins)"
        
        multi33Wins.text = "\(statisticsModel!.mp33Wins)"
        multi44Wins.text = "\(statisticsModel!.mp44Wins)"
    }

    @IBAction func resetSpEasyWins(_ sender: UIButton) {
    }

    @IBAction func resetSpMediumWins(_ sender: UIButton) {
    }
    
    @IBAction func resetSpHardWins(_ sender: UIButton) {
    }

    @IBAction func resetMp33Wins(_ sender: UIButton) {
    }

    @IBAction func resetMp44Wins(_ sender: UIButton) {
    }
    
}

