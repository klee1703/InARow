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
            stopAnimation(cell: cell)
            cell.isUserInteractionEnabled = true
            cell.isEnabled = true
            
            // Clear cell image
            cell.setImage(nil, for: .normal)
        }
    }
    
    func send(cell: UICellButton, petImage: UIImage?, opponentImage: UIImage?, boardView: UIView) {
        self.playLabel?.image = opponentImage
        
        // Delay to simulate opponent's move
        let randomNum = DispatchTimeInterval.seconds(Int(arc4random_uniform(3)+2))
        let when = DispatchTime.now() + randomNum // change to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Opponent made move, now re-enable play on board
            print("Opponent marked cell")
            boardView.isUserInteractionEnabled = true
            self.playLabel?.image = petImage
        }
    }
    
    func stopAnimation(cell: UICellButton) {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .allowUserInteraction, animations: {
            cell.alpha = 1.0
        }, completion: nil)
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
