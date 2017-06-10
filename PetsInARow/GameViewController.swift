//
//  FourthViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/6/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // Outlets
    @IBOutlet weak var boardView: BoardUIView!
    @IBOutlet weak var resultsLabel: UILabel!

    // Variables
    var gameBoard3x3: [String] = [String]()
    var gameBoard4x4: [String] = [String]()
    var gameBoard3x4: [String] = [String]()
    
    var tbvc: GameTabBarController?
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?
    var startLabel: String = "Let's Begin"
    var resultWin: String = "Congratulations on the Win!"
    var resultLoss: String = "Too bad, better luck next time"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
//        tbvc?.settings = settingsModel!
//        tbvc?.statistics = statisticsModel!
//        tbvc?.game = gameModel!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
 //       tbvc = (self.tabBarController as! GameTabBarController)
 //       settingsModel = tbvc!.settings
 //       statisticsModel = tbvc!.statistics
        
        resultsLabel.text = startLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(_ sender: UIButton) {
        statisticsModel?.singlePlayerEasyWins += 1
    }
    
    @IBAction func beginGame(_ sender: UIButton) {
        print("Begin Game")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func startGame(_ sender: UIButton) {
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            // Add tab bar controller to container view controller
            if let gbcvc = segue.destination as? GameBoardContainerViewController {
                gbcvc.tbvc = (self.tabBarController as! GameTabBarController)
            }
        }
    }
}
