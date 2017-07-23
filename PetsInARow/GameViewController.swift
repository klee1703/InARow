//
//  FourthViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/6/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import GameKit


class GameViewController: UIViewController {

    // Outlets
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var beginResumeGame: UIButton!
    @IBOutlet weak var activePet: UIImageView!
    @IBOutlet weak var match: UIButton!
    
    // Variables
    var isGameInPlay = false
    var gameBoard3x3: [String] = [String]()
    var gameBoard4x4: [String] = [String]()
    var gameCenterManager: GameCenterManager?

    var tbvc: GameTabBarController?
    var gbcvc: GameBoardContainerViewController?
    var loginAlert: UIAlertController?
    var displayName = ""
    
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
        gameCenterManager = GameCenterManager.INSTANCE(view: self, settings: settingsModel!, game: gameModel!)
        
        // Authenticate
        gameCenterManager?.authenticateLocalPlayer()
        
        // Instantiate login player
        loginAlert = UIAlertController(title: Constants.kGCLoginRequiredTitle, message: Constants.kGCLoginRequiredMessage, preferredStyle: .actionSheet)
        loginAlert?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Do any additional setup
        setup()
        settingsModel?.setupGame = false
        resultsLabel.text = Constants.kStartGameLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Authenticate
        GameCenterManager.INSTANCE(view: self, settings: settingsModel!, game: gameModel!)?.authenticateLocalPlayer()

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
            }
        }
        
        // if settings
        if (settingsModel?.setupGame)! {
            setup()
            doBegin()
            settingsModel?.setupGame = false
        }
        
        // Setup match button label if necessary
        if settingsModel?.gamePlayMode == EnumPlayMode.MultiPlayer {
            match.setTitle("End Match", for: .normal)
        } else {
            match.setTitle("", for: .normal)
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
        // End multiplayer match
//        gameModel?.match.parti
        print("Setup for New Game")
        // Initialize, game not started yet
        self.isGameInPlay = false
    }
    
    @IBAction func beginGame(_ sender: UIButton) {
        // Set game in play
        doBegin()
    }
    
    func doBegin() {
        print("Begin Game")
        self.isGameInPlay = true
        resultsLabel.text = Constants.kStartGameLabel
        
        // If board present clear
        if let board = gameModel?.board {
            gbcvc?.gbvc?.clearBoard(cells: (board))
        }
        
        // If play mode is single make first move accordingly
        if EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode {
            // If you have first move
            if settingsModel?.gameFirstMove == EnumFirstMove.Player {
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

    // Set label for the player's pet
    func setPlayerLabel(pet: String) {
        if settingsModel?.gameFirstMove == EnumFirstMove.Player {
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
            // Initialize container view controller and its width/height
            gbcvc = segue.destination as? GameBoardContainerViewController
            gbcvc?.widthHeight = CGFloat(containerView.layer.frame.width)

            // Add tab bar controller to container view controller
            gbcvc?.tbvc = (self.tabBarController as! GameTabBarController)
        }
    }
}
