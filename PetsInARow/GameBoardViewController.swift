//
//  GameBoardViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/10/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
    var pet: String?
    var playLabel: UIImageView?
    var isCurrentPlayer = true
    
    // Model variables
    var gameModel: GameModel?
    var statisticsModel: StatisticsModel?
    var settingsModel: SettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
        self.playLabel = gameModel?.playLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame(currentPlayer: Bool) {
        self.isCurrentPlayer = currentPlayer
    }
    
    func clearBoard(cells: [UICellButton]) {
        print("Clearing board")
        for cell in cells {
            // Clear board cell state
            cell.cellState = EnumCellState.None
            
            // Enable the cells
            cell.isUserInteractionEnabled = true
            
            // Clear cell image
            cell.setImage(nil, for: .normal)
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
