//
//  FirstViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/5/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Outlets
    @IBOutlet weak var pickerViewPet: UIPickerView!
    @IBOutlet weak var opponent: UISegmentedControl!
    @IBOutlet weak var gameBoard: UISegmentedControl!
    @IBOutlet weak var firstMove: UISegmentedControl!
    @IBOutlet weak var levelOfDifficulty: UISegmentedControl!
    @IBOutlet weak var gameCenter: UISwitch!
    @IBOutlet weak var soundEffects: UISwitch!    
    @IBOutlet weak var opponentsPet: UILabel!
    
    // Variables
    var petData = [String]()
    var gamePlayData = [Int]()
    var board: EnumGameBoard = .TTBoard
    var gamePlayMode: EnumPlayMode = .SinglePlayer
    var gameFirstMove: EnumFirstMove = .Me
    var yourPet = "Cat"
    var difficulty: EnumLevelOfDifficulty = .Easy
    var enableSoundEffects = true
    var enableGameCenter = true
    var isInitializedGameBoard = false
    var isInitializedGameCenter = false
    var isInitializedPlayMode = false
    
    var tbvc: GameTabBarController?
    var model: SettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        model = tbvc!.settings
        
        // Connect outlet
        self.pickerViewPet.delegate = self
        self.pickerViewPet.dataSource = self
        
        // Initialize data
        petData = EnumPet.values()
        gamePlayData = EnumPlayMode.values()
        
        // Initialize components
        controlOpponent(opponent)
        controlGameBoard(gameBoard)
        controlFirstMove(firstMove)
        controlLevelOfDifficulty(levelOfDifficulty)
        switchGameCenter(gameCenter)
        switchSoundEffects(soundEffects)
        
        //gameBoard.selectedSegmentIndex =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return petData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return petData[row]
    }

    // 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        yourPet = petData[row]
        model?.yourPet = petData[row]
    }
    
    // Set view for picker
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;

        // Instantiate picker if necessary
        if (nil == pickerLabel) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 12)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor.white
        }

        // Retrieve label for picker
        pickerLabel?.text = petData[row]
        
        return pickerLabel!
    }

    
    @IBAction func switchSoundEffects(_ sender: UISwitch) {
        if sender.isOn {
            enableSoundEffects = true
            model?.enableSoundEffects = true
        } else {
            enableSoundEffects = false
            model?.enableSoundEffects = false
        }
    }

    @IBAction func switchGameCenter(_ sender: UISwitch) {
        // Present alert if necessary
        if isInitializedGameCenter {
            let alert = UIAlertController(title: "Game Center", message: "Are you sure you want to enable/disable Game Center?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdateGameCenter(true, isEnabled: sender.isOn)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) {action in
                self.doUpdateGameCenter(false, isEnabled: sender.isOn)
            })
            present(alert, animated: true, completion: nil)
        } else {
            // Past initialization, from now on present alerts
            isInitializedGameCenter = true
        }
    }
    
    func doUpdateGameCenter(_ updateGameCenter: Bool, isEnabled: Bool) {
        // Update game center if necessary
        if updateGameCenter {
            if isEnabled {
                // Enabling game center, update accordingly
                enableGameCenter = true
                model?.enableGameCenter = true
                opponent.setEnabled(true, forSegmentAt: EnumPlayMode.SinglePlayer.rawValue)
                opponent.setEnabled(true, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                if (opponent.selectedSegmentIndex == EnumPlayMode.MultiPlayer.rawValue) {
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                } else {
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                    
                }
            } else {
                // Disabling game center, update accordingly
                enableGameCenter = false
                model?.enableGameCenter = false
                opponent.selectedSegmentIndex = EnumPlayMode.SinglePlayer.rawValue
                opponent.setEnabled(false, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)
                gameBoard.selectedSegmentIndex = EnumGameBoard.TTBoard.rawValue
                gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
            }
        }
    }

    @IBAction func controlGameBoard(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.board = .TTBoard
            model?.board = .TTBoard
        case 1:
            self.board = .FFBoard
            model?.board = .FFBoard
        default:
            self.board = .TTBoard
            model?.board = .TTBoard
        }

        if isInitializedGameBoard {
            let alert = UIAlertController(title: "Game Board", message: "Are you sure you want to update the Game Board?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdateGameBoard(true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) {action in
                self.doUpdateGameBoard(false)
            })
            present(alert, animated: true, completion: nil)
        } else {
            // Past initialization, from now on present alerts
            isInitializedGameBoard = true
        }
    }
    
    func doUpdateGameBoard(_ updateGameBoard: Bool) {
        // Update game board if necessary
        if updateGameBoard {
            if (EnumGameBoard.FFBoard == self.board) {
                // 4x4 board, update accordingly
                opponent.selectedSegmentIndex = EnumPlayMode.MultiPlayer.rawValue
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
            } else {
                // 3x3 board, update accordingly
                opponent.setEnabled(true, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)
                opponent.setEnabled(true, forSegmentAt: EnumPlayMode.SinglePlayer.rawValue)
                gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                if (EnumPlayMode.SinglePlayer == gamePlayMode) {
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                } else {
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                }
            }
        }
    }

    @IBAction func controlOpponent(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gamePlayMode = .SinglePlayer
            model?.gamePlayMode = .SinglePlayer
        case 1:
            self.gamePlayMode = .MultiPlayer
            model?.gamePlayMode = .MultiPlayer
        default:
            self.gamePlayMode = .SinglePlayer
            model?.gamePlayMode = .SinglePlayer
        }

        if isInitializedPlayMode {
            isInitializedGameBoard = true
            let alert = UIAlertController(title: "Game Play Mode", message: "Are you sure you want to update the Play Mode?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdatePlayMode(true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) {action in
                self.doUpdatePlayMode(false)
            })
            present(alert, animated: false, completion: nil)
        } else {
            // Past initialization, from now on present alerts
            isInitializedPlayMode = true
        }
    }
    
    func doUpdatePlayMode(_ updatePlayMode: Bool) {
        // Update play mode if necessary
        if updatePlayMode {
            if (EnumPlayMode.SinglePlayer == gamePlayMode) {
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                gameBoard.selectedSegmentIndex = EnumGameBoard.TTBoard.rawValue
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
            } else {
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
            }
        }
    }

    @IBAction func controlFirstMove(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gameFirstMove = .Me
            model?.gameFirstMove = .Me
        case 1:
            self.gameFirstMove = .Opponent
            model?.gameFirstMove = .Opponent
        default:
            self.gameFirstMove = .Me
            model?.gameFirstMove = .Me
        }
    }

    @IBAction func controlLevelOfDifficulty(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.difficulty = .Easy
            model?.difficulty = .Easy
        case 1:
            self.difficulty = .Medium
            model?.difficulty = .Medium
        case 2:
            self.difficulty = .Hard
            model?.difficulty = .Hard
        default:
            self.difficulty = .Easy
            model?.difficulty = .Easy
        }
    }
    
}

