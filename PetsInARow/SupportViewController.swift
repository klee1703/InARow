//
//  ThirdViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/6/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {
    let HELP_TEXT = "3 In A Row! is a version of the classic tic-tac-toe board game. It is played by two opponents (player and computer), who take turns marking the squares on the game board, a 3 x 3 grid. The object of the game is to place three successive marks in a horizontal, vertical, or diagonal row on the grid. The opponents alternate moves, with the player touching the desired square in the grid to place a mark, followed by the computer marking a square.  The opponent who first obtains three-in-a-row wins; if neither opponent is able to obtain three-in-a-row and all moves are exhausted the game is declared a draw.\n\nGame Play\nAt startup 3 In A Row! displays the game board on the playing screen. If the player is configured to make the first move, he touches the desired square on the board to place a mark in the square. The computer then responds by marking one of the board squares. (Note that if the computer is configured to make the first move it marks one of the board squares when the New Game button is selected).\nAt the conclusion of a game the playing screen displays the outcome (win, loss, or draw). To quit a game in progress and start a new game the player touches the New Game button.\nTo view/update game statistics, configure game settings, access Game Center, or view help info, the player accesses the game menu by touching the info icon at the top of the playing screen.\n\nGame Interface\nThe game interface includes a playing screen and several additional screens used to perform game configuration and review game stats.\nPlaying screen: consists of the game board, an info icon (click to display the menu screen), a game status field (displays game win, lose, draw status), and a New Game button (touch to start a new game).\nMenu screen: resume an in-progress game, start a new game, select the game settings screen, select the statistics screen, select the help screen, or access Game Center.\nSettings screen: turn on/off sound effects, control sound effects volume, select the appropriate pet (cat or dog) for the player, select which opponent (player or computer) makes first game move, select game level-of-difficulty (easy, medium, hard), start/resume a game, display the menu screen (info icon).\nStatistics screen: View and reset win/loss/draw statistics for player, start/resume a game, display the menu screen (info icon).\nHelp screen: view this help info, display the menu screen (info icon).\nGame Center screen: access Game Center, where the player can review achievements and/or issue challenges to friends.\n\nGame Settings\nSound Fx: Enable/disable sound effects played on each move and when a game is completed.\nSound Level: Set the volume for sound effects.\nFirst Move: select Player or Computer to configure which opponent makes the first move in a game.\nPlayer Pet: select the pet (cat or dog) that is used to mark the player's squares on the game board; the computer then uses the other pet to mark its squares.\nLevel of Difficulty: The game has three levels of difficulty - easy/medium/hard; select the desired level for a game. If the selection is made during a game in progress, a new game will be started.\n\nStatistics\nThe statistics screen displays the number of wins, losses, and draws for the player at each level-of-difficulty. The stats for a level can be reset by touching the corresponding clear stats (X) button.\n\nSGame Center\n Game Center is the Apple social gaming network.  From this app you can view your current achievements for 3 In A Row! and issue challenges to friends."
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
