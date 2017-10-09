//
//  GameBoardViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/10/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import GameKit

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
 
    // Send data for multiplayer game!
    func send(cellIndex: Int, playerImageFile:String, opponentImageFile:String, gameBoard: EnumGameBoard, boardView: UIView) {
        
        // Delay to simulate opponent's move
        let randomNum = DispatchTimeInterval.seconds(Int(arc4random_uniform(3)+2))
        let when = DispatchTime.now() + randomNum // change to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Opponent made move, now re-enable play on board
            print("Opponent marked cell")
            boardView.isUserInteractionEnabled = true
//            self.playLabel?.image = petImage
        }

        // Create a GKMatch instance for sending data
        let match = gameModel?.match
        
        // Create a data instance and populate with data
            var packet = GamePacket(playerMove: true, cellIndex: cellIndex, playermageFileName: playerImageFile, opponentImageFileName: opponentImageFile, gameBoard: gameBoard)
        let dataPacket = NSData(bytes: &packet, length: MemoryLayout<GamePacket>.size)
        boardView.isUserInteractionEnabled = false
        
        do {
            try match?.sendData(toAllPlayers: dataPacket as Data, with: GKMatchSendDataMode.reliable)
        } catch {
            print("Error sending data")
        }
        
    }
    
    // Receive data for multiplayer game!
    func receive(match: GKMatch, data: Data, remotePlayer: GKPlayer) {
        
    }
    
    func stopAnimation(cell: UICellButton) {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .allowUserInteraction, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
    
    func boardIndex(cell: UICellButton, cells: [UICellButton]) -> Int {
        for index in 0..<cells.count {
            if cells[index] == cell {
                return index
            }
        }
        return -1
        
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
