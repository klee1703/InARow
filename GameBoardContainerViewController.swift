//
//  GameBoardContainerViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/1/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameBoardContainerViewController: UIViewController {
    let gameBoard33Segue = "Board33Segue"
    let gameBoard44Segue = "Board44Segue"
    let widthHeight = 343
    var tbvc: GameTabBarController?
    var gbvc: GameBoardViewController?
    
    // Model variables
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?
    
    var currentSegueIdentifier = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingsModel = tbvc!.settings
        /*
        switch settingsModel!.board {
        case EnumGameBoard.TTBoard:
            self.currentSegueIdentifier = gameBoard33Segue
        case EnumGameBoard.FFBoard:
            self.currentSegueIdentifier = gameBoard44Segue
        }
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
 */
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        switch settingsModel!.board {
        case EnumGameBoard.TTBoard:
            self.currentSegueIdentifier = gameBoard33Segue
        case EnumGameBoard.FFBoard:
            self.currentSegueIdentifier = gameBoard44Segue
        }
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == gameBoard33Segue {
            gbvc = segue.destination as? GameBoard33ViewController
            if self.childViewControllers.count > 0 {
                self.swap(from: self.childViewControllers[0], to: segue.destination)
            } else {
                self.addChildViewController(segue.destination)
                segue.destination.view.frame = CGRect(x:0, y:0, width:widthHeight, height:widthHeight)
                self.view.addSubview(segue.destination.view)
                segue.destination.didMove(toParentViewController: self)
            }
        } else if segue.identifier == gameBoard44Segue {
            gbvc = segue.destination as? GameBoard44ViewController
            self.swap(from: self.childViewControllers[0], to: segue.destination)
        }
    }
    
    func swap(from: UIViewController, to: UIViewController) {
//        to.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        to.view.frame = CGRect(x:0, y:0, width:widthHeight, height:widthHeight)
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)
        self.transition(from: from, to: to, duration: 1.0, options: .transitionCrossDissolve, animations: nil, completion: nil)
        from.removeFromParentViewController()
        to.didMove(toParentViewController: self)
    }
    
    func swap() {
        self.currentSegueIdentifier = self.currentSegueIdentifier == gameBoard33Segue ? gameBoard33Segue : gameBoard44Segue
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
    }
}
