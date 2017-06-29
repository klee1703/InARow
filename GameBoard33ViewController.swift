//
//  GameBoardViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameBoard33ViewController: GameBoardViewController {
    // Cells
    @IBOutlet weak var cell0: UICellButton!
    @IBOutlet weak var cell1: UICellButton!
    @IBOutlet weak var cell2: UICellButton!
    @IBOutlet weak var cell3: UICellButton!
    @IBOutlet weak var cell4: UICellButton!
    @IBOutlet weak var cell5: UICellButton!
    @IBOutlet weak var cell6: UICellButton!
    @IBOutlet weak var cell7: UICellButton!
    @IBOutlet weak var cell8: UICellButton!
    
    @IBOutlet var gameBoard33View: UIView!
    
    var cells: [UICellButton] = []
    var labelPetImage = UIImage()
    var labelOpponentImage = UIImage()
    var labelComputerImage = UIImage()
    
    var gameEngine: GameEngine33?
    var gameEngineAI: GameEngineAI?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cells = [cell0, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8]
        gameModel?.board = cells
        gameEngine = GameEngine33(cells: cells, settings: settingsModel!, statistics: statisticsModel!)
        gameEngineAI = GameEngineAI(cells: cells, settings: settingsModel!, statistics: statisticsModel!)
        
        // Interaction enable
        gameBoard33View.isUserInteractionEnabled = true
        
        labelPetImage = UIImage(named: (settingsModel?.yourPet)! + ".png")!
        labelOpponentImage = UIImage(named: (settingsModel?.opponentsPet)! + ".png")!
        labelComputerImage = UIImage(named: Constants.kComputerImageFile)!
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
        gameBoard33View.isUserInteractionEnabled = false
        
        // Update the board cell state (including number of moves played)
        let cell = sender as! UICellButton
        cell.cellState = EnumCellState.Player
        gameEngine?.incrementMovesPlayed()
        
        // Check if tic-tac-toe or draw condition
        if (gameEngine?.isTicTacToe(cells: cells, cellState: EnumCellState.Player))! {
            print("Player has Tic Tac Toe!")
            // Play win sound
            if (settingsModel?.enableSoundEffects)! {
                AudioManager.INSTANCE()?.playerWin?.play()
            }
            
            // Display on view and disable user interaction
            gameModel?.resultsLabel?.text = Constants.kPlayerWinLabel
            gameBoard33View.isUserInteractionEnabled = false
            
            // Update statistics - add win
            gameEngine?.addWin(difficulty: (settingsModel?.difficulty)!, board: (settingsModel?.board)!, playMode: (settingsModel?.gamePlayMode)!)
        } else if (gameEngine?.isDrawCondition(cells: cells))! {
            // Play draw sound
            if (settingsModel?.enableSoundEffects)! {
                AudioManager.INSTANCE()?.draw?.play()
            }

            // Draw condition, display on view and disable user interaction
            gameModel?.resultsLabel?.text = Constants.kDrawLabel
            gameBoard33View.isUserInteractionEnabled = false
        } else {
            // Now let the opponent mark the board - single player or multiplayer
            
            // If Single Player next mark board using AI engine
            if super.settingsModel?.gamePlayMode == .SinglePlayer {
                print("Computer play")
                // First update number of moves played
                gameEngineAI?.incrementMovesPlayed()

                // Then mark the board using AI engine
                aiMarkCell(cells: cells)
            } else {
                // MultiPlayer, send message to enable opponent to mark board
                send(cell: cell, petImage: labelPetImage, opponentImage: labelOpponentImage, boardView: gameBoard33View)
                
                // Update the board state
                gameEngine?.incrementMovesPlayed()
                
                // Now check for Tic Tac Toe
                if (gameEngine?.isTicTacToe(cells: cells, cellState: EnumCellState.Opponent))! {
                    // Play loss sound
                    if (settingsModel?.enableSoundEffects)! {
                        AudioManager.INSTANCE()?.opponentWin?.play()
                    }
                    
                    // Display on view and disable user interaction
                    gameModel?.resultsLabel?.text = Constants.kOpponentWinLabel
                    gameBoard33View.isUserInteractionEnabled = false
                } else if (gameEngine?.isDrawCondition(cells: cells))! {
                    // Play draw sound
                    if (settingsModel?.enableSoundEffects)! {
                        AudioManager.INSTANCE()?.draw?.play()
                    }
                    
                    // Draw condition, display on view and disable user interaction
                    gameModel?.resultsLabel?.text = Constants.kDrawLabel
                    gameBoard33View.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    override func startGame(currentPlayer: Bool) {
        super.startGame(currentPlayer: currentPlayer)
        
        print("Start game")
        super.gameModel?.board = cells
        gameBoard33View.isUserInteractionEnabled = true
        gameEngineAI?.resetMovesPlayed()
        
        if !currentPlayer && (settingsModel?.gamePlayMode == .SinglePlayer) {
            // First move for opponent in Single Player mode, use AI for first move
            aiMarkCell(cells: cells)
        }
    }
    
    func aiMarkCell(cells: [UICellButton]) {
        super.playLabel?.image = self.labelComputerImage
        let randomNum = Int(arc4random_uniform(1)+2)
        let when = DispatchTime.now() + .seconds(randomNum)
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            // Use AI engine to mark best available cell
            print("AI marked cell")
            self.gameEngine?.markCell(image: self.labelComputerImage)
            super.playLabel?.image = self.labelPetImage
            
            // Play mark sound
            if (self.settingsModel?.enableSoundEffects)! {
                AudioManager.INSTANCE()?.opponentMark?.play()
            }
            
            // Increment number of marks on board
            self.gameEngineAI?.incrementMovesPlayed()
            
            // Check if tic-tac-toe
            if (self.gameEngine?.isTicTacToe(cells: cells, cellState: EnumCellState.Opponent))! {
                print("Computer has Tic Tac Toe!")
                // Play loss sound
                if (self.settingsModel?.enableSoundEffects)! {
                    AudioManager.INSTANCE()?.opponentWin?.play()
                }
                
                // Display on view and disable user interaction
                self.gameModel?.resultsLabel?.text = Constants.kComputerWinLabel
                self.gameBoard33View.isUserInteractionEnabled = false
            } else if (self.gameEngineAI?.isDrawCondition())! {
                // Play draw sound
                if (self.settingsModel?.enableSoundEffects)! {
                    AudioManager.INSTANCE()?.draw?.play()
                }
                
                // Draw condition, display on view and disable user interaction
                self.gameModel?.resultsLabel?.text = Constants.kDrawLabel
                self.gameBoard33View.isUserInteractionEnabled = false
            } else {
                // No loss or draw, game continues, re-enable play on board
                self.gameBoard33View.isUserInteractionEnabled = true
                self.playLabel?.image = self.labelPetImage
            }
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

}
