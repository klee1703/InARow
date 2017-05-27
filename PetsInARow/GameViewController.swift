//
//  FourthViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/6/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardUIView!
    
    // Variables
    var gameBoard3x3: [String] = [String]()
    var gameBoard4x4: [String] = [String]()
    var gameBoard3x4: [String] = [String]()
    
    var tbvc: GameTabBarController?
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        gameModel = tbvc!.game
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        tbvc = (self.tabBarController as! GameTabBarController)
        settingsModel = tbvc!.settings
        statisticsModel = tbvc!.statistics
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(_ sender: UIButton) {
        statisticsModel?.spEasyWins += 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
