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
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var beginResumeGame: UIButton!
    @IBOutlet weak var activePet: UIImageView!
    
    // Constants
    let startLabel: String = "Let's Begin"
    let resultWin: String = "Congratulations on the Win!"
    let resultLoss: String = "Too bad, better luck next time"
    
    // Variables
    var isGameInPlay = false
    var gameBoard3x3: [String] = [String]()
    var gameBoard4x4: [String] = [String]()
    
    var tbvc: GameTabBarController?
    var gbcvc: GameBoardContainerViewController?
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?
    
    var isCurrentPlayer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tbvc = (self.tabBarController as! GameTabBarController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
        beginResumeGame.setTitle("Begin Game", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        resultsLabel.text = startLabel
        
        if EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode {
            if isCurrentPlayer {
                setPlayerLabel(pet: (settingsModel?.yourPet)!)

            } else {
                setPlayerLabel(pet: "Computer.png")
            }
        } else {
            if isCurrentPlayer {
                setPlayerLabel(pet: (settingsModel?.yourPet)!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(_ sender: UIButton) {
        print("Begin Game")
        statisticsModel?.singlePlayerEasyWins += 1
        self.isGameInPlay = false
        beginResumeGame.setTitle("Begin Game", for: .normal)
        
        // Clear board
        if let gbController = gbcvc {
            gbController.gbvc?.clearBoard()
        }
    }
    
    @IBAction func beginGame(_ sender: UIButton) {
        // Set game in play and update button
        print("Begin Game")
        self.isGameInPlay = true
        beginResumeGame.setTitle("Resume Game", for: .normal)

        // If play mode is single make first move accordingly
        if EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode {
            // If you have first move
            if settingsModel?.gameFirstMove == EnumFirstMove.Me {
                // Set to current player
                isCurrentPlayer = true
                
                // Set move player label and make first move
                setPlayerLabel(pet: (settingsModel?.yourPet)!)
                
            } else {
                // Set opponent to current player and use AI to make first move
                isCurrentPlayer = false
                
                // Set move player label and make first move
                setPlayerLabel(pet: "Computer.png")
            }
        } else {
            // Set move player label
            if isCurrentPlayer {
                setPlayerLabel(pet: (settingsModel?.yourPet)!)
            }
        }
    }
    
    func setPlayerLabel(pet: String) {
        if settingsModel?.gameFirstMove == EnumFirstMove.Me {
            activePet.image = UIImage(named: (settingsModel?.yourPet)! + ".png")
        } else {
            activePet.image = UIImage(named: (settingsModel?.opponentsPet)! + ".png")
            
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            // Add tab bar controller to container view controller
            gbcvc = segue.destination as? GameBoardContainerViewController
            gbcvc?.tbvc = (self.tabBarController as! GameTabBarController)
        }
    }
}
