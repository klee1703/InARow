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
    
    var gameEngine = GameEngine33()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cells = [cell0, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8]
        gameModel?.board = cells
        
        // Interaction enable
        gameBoard33View.isUserInteractionEnabled = true
        
        labelPetImage = UIImage(named: (settingsModel?.yourPet)! + ".png")!
        labelOpponentImage = UIImage(named: (settingsModel?.opponentsPet)! + ".png")!
        labelComputerImage = UIImage(named: "Computer.png")!
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
        
        // Disable interaction with cell (can't be pressed again!)
        sender.isUserInteractionEnabled = false
        
        // Disable interaction on board (can't press another cell until after move by opponent!)
        gameBoard33View.isUserInteractionEnabled = false
        
        // Update the board cell state
        let cell = sender as! UICellButton
        cell.cellState = EnumCellState.Player
        
        // Check if tic-tac-toe
        if gameEngine.isTicTacToe(cells: cells, cellState: EnumCellState.Player) {
            print("Player has Tic Tac Toe!")
            gameModel?.resultsLabel?.text = gameModel?.winLabel
            
            // Display win message
            
        } else {
            // If Single Player next perform AI play
            if super.settingsModel?.gamePlayMode == .SinglePlayer {
                print("Computer play")
                aiMarkCell(cells: cells)
            }
        }
    }
    
    override func startGame(currentPlayer: Bool) {
        super.startGame(currentPlayer: currentPlayer)
        print("Start game")
        super.gameModel?.board = cells
        gameBoard33View.isUserInteractionEnabled = true
    }
    
    func aiMarkCell(cells: [UICellButton]) {
        super.playLabel?.image = self.labelComputerImage
        let randomNum = Int(arc4random_uniform(3)+2)
        let when = DispatchTime.now() + .seconds(randomNum)
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            // Use AI engine to mark best available cell
            print("AI marked cell")
            self.gameEngine.markCell(cells: cells)
            super.playLabel?.image = self.labelPetImage
            
            // Check if tic-tac-toe
            if self.gameEngine.isTicTacToe(cells: cells, cellState: EnumCellState.Opponent) {
                print("Computer has Tic Tac Toe!")
                self.gameModel?.resultsLabel?.text = self.gameModel?.lossLabel
                
                // Display win message
            } else {
                
                // Re-enable play on board
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
