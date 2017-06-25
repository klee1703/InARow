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
        gameEngine = GameEngine44(settings: settingsModel!, statistics: statisticsModel!)
        
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
        sender.setImage(cellPetImage, for: .normal)
        
        // Disable interaction with cell (can't be pressed again!)
        sender.isUserInteractionEnabled = false
        
        // Disable interaction on board (can't press another cell until after move by opponent!)
        gameBoard44View.isUserInteractionEnabled = false
        print(gameBoard44View.isUserInteractionEnabled)
        
        // Update the board cell state
        let cell: UICellButton = sender as! UICellButton
        cell.cellState = EnumCellState.Player
        
        // Check if tic-tac-toe
        if (gameEngine?.isTicTacToe(cells: cells, cellState: cell.cellState))! {
            // Display win message and prompt for a new game
            print("Player has Tic Tac Toe!")
            gameModel?.resultsLabel?.text = Constants.kPlayerWinLabel
        } else {
            // MultiPlayer, send message to enable move by opponent
            send(cell: cell, petImage: labelPetImage, opponentImage: labelOpponentImage, boardView: gameBoard44View)
            if (gameEngine?.isTicTacToe(cells: cells, cellState: EnumCellState.Opponent))! {
                gameModel?.resultsLabel?.text = Constants.kOpponentWinLabel
                gameBoard44View.isUserInteractionEnabled = false
            }
        }
    }
    
    override func startGame(currentPlayer: Bool) {
        super.startGame(currentPlayer: currentPlayer)
        print("Start game")
        super.gameModel?.board = cells
        gameBoard44View.isUserInteractionEnabled = true
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
