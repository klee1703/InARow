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
    
    // Variables
    var isGameInPlay = false
    var gameBoard3x3: [String] = [String]()
    var gameBoard4x4: [String] = [String]()
    
    var tbvc: GameTabBarController?
    var gbcvc: GameBoardContainerViewController?
    
    // Model variables
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?
    
    var isCurrentPlayer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve models.
        tbvc = (self.tabBarController as! GameTabBarController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
        gameModel?.playLabel = activePet
        gameModel?.resultsLabel = resultsLabel
        
        // Do any additional setup
        setup()
        resultsLabel.text = gameModel?.startGame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set player label based on play mode and current player
        if EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode {
            if isCurrentPlayer {
                setPlayerLabel(pet: (settingsModel?.yourPet)!)

            } else {
                setPlayerLabel(pet: "Computer.png")
            }
        } else {
            if isCurrentPlayer {
                setPlayerLabel(pet: (settingsModel?.yourPet)!)
            } else {
                //
            }
        }
        
        // if settings
        if (settingsModel?.setupGame)! {
            setup()
            doBegin()
            settingsModel?.setupGame = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(_ sender: UIButton) {
        setup()
    }

    func setup() {
        print("Setup for New Game")
        // Initialize, game not started yet
        self.isGameInPlay = false
        
        // TEST!
        statisticsModel?.singlePlayerEasyWins += 1
    }
    
    @IBAction func beginGame(_ sender: UIButton) {
        // Set game in play
        doBegin()
    }
    
    func doBegin() {
        print("Begin Game")
        self.isGameInPlay = true
        resultsLabel.text = gameModel?.startGame
        
        // If board present clear
        if let board = gameModel?.board {
            gbcvc?.gbvc?.clearBoard(cells: (board))
        }
        
        // If play mode is single make first move accordingly
        if EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode {
            // If you have first move
            if settingsModel?.gameFirstMove == EnumFirstMove.Me {
                // Set to current player
                isCurrentPlayer = true
                gameModel?.playState = .PlayerTurn
                
                // Set move player label and start game (make first move)
                let yourPet = (settingsModel?.yourPet)!
                setPlayerLabel(pet: yourPet)
                gbcvc?.gbvc?.startGame(currentPlayer: isCurrentPlayer)
                
            } else {
                // Set opponent to current player
                isCurrentPlayer = false
                gameModel?.playState = .OpponentTurn
                
                // Set move player label and use AI to start game
                setPlayerLabel(pet: "Computer.png")
                gbcvc?.gbvc?.startGame(currentPlayer: isCurrentPlayer)
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
