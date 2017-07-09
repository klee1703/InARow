//
//  GameBoard44ViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameBoard44ViewController: GameBoardViewController {
    
    @IBOutlet weak var cell0: UICellButton!
    @IBOutlet weak var cell1: UICellButton!
    @IBOutlet weak var cell2: UICellButton!
    @IBOutlet weak var cell3: UICellButton!
    @IBOutlet weak var cell4: UICellButton!
    @IBOutlet weak var cell5: UICellButton!
    @IBOutlet weak var cell6: UICellButton!
    @IBOutlet weak var cell7: UICellButton!
    @IBOutlet weak var cell8: UICellButton!
    @IBOutlet weak var cell9: UICellButton!
    @IBOutlet weak var cell10: UICellButton!
    @IBOutlet weak var cell11: UICellButton!
    @IBOutlet weak var cell12: UICellButton!
    @IBOutlet weak var cell13: UICellButton!
    @IBOutlet weak var cell14: UICellButton!
    @IBOutlet weak var cell15: UICellButton!

    @IBOutlet var gameBoard44View: UIView!
    
    var cells: [UICellButton] = []
    var labelPetImage: UIImage?
    var labelOpponentImage: UIImage?
    var cellPetImage: UIImage?
    
    var gameEngine: GameEngine44?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cells = [cell0, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, cell13, cell14, cell15]
        gameModel?.board = cells
        gameEngine = GameEngine44(movesPlayed: 0, settings: settingsModel!, statistics: statisticsModel!)
        
        // Interaction initially enabled
        gameBoard44View.isUserInteractionEnabled = true

        labelPetImage = UIImage(named: (settingsModel?.yourPet)! + ".png")
        labelOpponentImage = UIImage(named: (settingsModel?.opponentsPet)! + ".png")!
        cellPetImage = UIImage(named: (settingsModel?.yourPet)! + ".png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cellPressed(_ sender: UIButton) {
        print("Cell pressed!")
        
        // Set cell image
        let petImage = UIImage(named: (settingsModel?.yourPet)! + ".png")
        sender.setImage(petImage, for: .normal)
        
        // Play mark sound
        if (settingsModel?.enableSoundEffects)! {
            AudioManager.INSTANCE()?.playerMark?.play()
        }
        
        // Disable interaction with cell (can't be pressed again!)
        sender.isUserInteractionEnabled = false
        
        // Disable interaction on board (can't press another cell until after move by opponent!)
        gameBoard44View.isUserInteractionEnabled = false
        print(gameBoard44View.isUserInteractionEnabled)
        
        // Update the board cell state (including number of moves played)
        let cell: UICellButton = sender as! UICellButton
        cell.cellState = EnumCellState.Player
        gameEngine?.incrementMovesPlayed()
        
        // Check if tic-tac-toe
        if (gameEngine?.isTicTacToe(cells: cells, cellState: cell.cellState))! {
            // Display win message and prompt for a new game
            print("Player has Tic Tac Toe!")
            // Play win sound
            if (settingsModel?.enableSoundEffects)! {
                AudioManager.INSTANCE()?.playerWin?.play()
            }
            
            // Display on view and disable user interaction
            gameModel?.resultsLabel?.text = Constants.kPlayerWinLabel
            gameEngine?.addWin(board: (settingsModel?.board)!)
        } else if (gameEngine?.isDrawConditionForBoard())! {
            // Play draw sound
            if (settingsModel?.enableSoundEffects)! {
                AudioManager.INSTANCE()?.draw?.play()
            }
            
            // Draw condition, display on view and disable user interaction
            gameModel?.resultsLabel?.text = Constants.kDrawLabel
            gameBoard44View.isUserInteractionEnabled = false
        } else {
            // MultiPlayer, send message to enable move by opponent
            send(cell: cell, petImage: labelPetImage, opponentImage: labelOpponentImage, boardView: gameBoard44View)
            
            // Update the board state for opponent's move
            gameEngine?.incrementMovesPlayed()
            
            // Now check for Tic Tac Toe
            if (gameEngine?.isTicTacToe(cells: cells, cellState: EnumCellState.Opponent))! {
                // Play loss sound
                if (settingsModel?.enableSoundEffects)! {
                    AudioManager.INSTANCE()?.opponentWin?.play()
                }
                
                // Display on view and disable user interaction
                gameModel?.resultsLabel?.text = Constants.kOpponentWinLabel
                gameBoard44View.isUserInteractionEnabled = false
            } else if (gameEngine?.isDrawConditionForBoard())! {
                // Play draw sound
                if (settingsModel?.enableSoundEffects)! {
                    AudioManager.INSTANCE()?.draw?.play()
                }
                
                // Draw condition, display on view and disable user interaction
                gameModel?.resultsLabel?.text = Constants.kDrawLabel
                gameBoard44View.isUserInteractionEnabled = false
            }
        }
    }
    
    override func startGame(currentPlayer: Bool) {
        super.startGame(currentPlayer: currentPlayer)
        print("Start game")
        super.gameModel?.board = cells
        gameBoard44View.isUserInteractionEnabled = true
        
        // Reset moves played
        gameEngine?.movesPlayed = 0
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
