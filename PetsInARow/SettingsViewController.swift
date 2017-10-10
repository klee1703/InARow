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
    
    // Flags to initialize settings
    var isInitializedGameBoard = false
    var isInitializedGameCenter = false
    var isInitializedPlayMode = false
    var isInitializedLevelOfDifficulty = false

    // Tab bar controller
    var tbvc: GameTabBarController?
    
    // Model data for settings
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tbvc = (self.tabBarController as! GameTabBarController)
        settingsModel = tbvc!.settings
        
        // Connect outlet
        self.pickerViewPet.delegate = self
        self.pickerViewPet.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
        
        // Initialize data
        petData = EnumPet.values()
        gamePlayData = EnumPlayMode.values()
        settingsModel?.opponentsPet = getOpponentsPet(yourPet: (settingsModel?.yourPet)!)
        
        // Initialize components
        controlOpponent(opponent)
        controlGameBoard(gameBoard)
        controlFirstMove(firstMove)
        controlLevelOfDifficulty(levelOfDifficulty)
        switchGameCenter(gameCenter)
        switchSoundEffects(soundEffects)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set components
        if isInitializedGameCenter {
            self.doUpdateGameCenter(true, isEnabled: gameCenter.isOn)
        }
        if isInitializedPlayMode {
            self.doUpdatePlayMode(true)
        }
        if isInitializedGameBoard {
            self.doUpdateGameBoard(true)
        }
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

    // Get selected pet
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        settingsModel?.yourPet = petData[row]
        let alert = UIAlertController(title: "New Player Pet", message: "Begins a New Game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default) {action in
            print("Pet changed")
            self.settingsModel?.setupGame = true
        })
        present(alert, animated: true, completion: nil)
        
        // Now set the opponent's pet, not the same as your pet!
        settingsModel?.opponentsPet = getOpponentsPet(yourPet: (settingsModel?.yourPet)!)
    }
    
    func getOpponentsPet(yourPet: String) -> String {
        // Retrieve pet collection
        var temp = petData
        
        // Remove your pet from collection
        if let index = petData.index(of: yourPet) {
            temp.remove(at: index)
            
            // Randomly select from collection and return
            let randomNum = arc4random_uniform(UInt32(temp.count))
            return temp[Int(randomNum)]
        }
        
        // Not found, return dummy pet
        return "dummyPet"
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
            settingsModel?.enableSoundEffects = true
        } else {
            settingsModel?.enableSoundEffects = false
        }
    }

    @IBAction func switchGameCenter(_ sender: UISwitch) {
        // Present alert if necessary
        let previousSetting = !sender.isOn
        if isInitializedGameCenter {
            let alert = UIAlertController(title: "Game Center", message: Constants.kGameCenterMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdateGameCenter(true, isEnabled: sender.isOn)
                self.settingsModel?.setupGame = true
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) {action in
                self.doUpdateGameCenter(false, isEnabled: sender.isOn)
                sender.setOn(previousSetting, animated: false)
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
                settingsModel?.enableGameCenter = true

                // Enable/disable options based on existing play mode setting
                if (settingsModel?.gamePlayMode == EnumPlayMode.SinglePlayer) {
                    // Game play mode single player, enable/disable game play mode options
                    opponent.setEnabled(true, forSegmentAt: EnumPlayMode.SinglePlayer.rawValue)
                    opponent.setEnabled(true, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)
                    
                    // Enable/disable game board options
                    gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                    gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                } else {
                    // Game play mode multiplayer, enable/disable game play mode options
                    opponent.setEnabled(true, forSegmentAt: EnumPlayMode.SinglePlayer.rawValue)
                    opponent.setEnabled(true, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)
                    
                    // Enable/disable game board options
                    gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                    gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                }
                
                // Enable/disable level-of-difficulty based on game play mode segment
                if (opponent.selectedSegmentIndex == EnumPlayMode.MultiPlayer.rawValue) {
                    // Multiplayer mode selected, disable level-of-difficulty selection
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                } else {
                    // Single player mode selected, enable level-of-difficulty selection
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                    levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)                    
                }
            } else {
                // Game center disabled, update accordingly
                settingsModel?.enableGameCenter = false
                
                // Enable/disable play mode options
                settingsModel?.gamePlayMode = .SinglePlayer
                opponent.selectedSegmentIndex = (settingsModel?.gamePlayMode.rawValue)!
                opponent.setEnabled(true, forSegmentAt: EnumPlayMode.SinglePlayer.rawValue)
                opponent.setEnabled(false, forSegmentAt: EnumPlayMode.MultiPlayer.rawValue)

                // Set game board options
                settingsModel?.board = .TTBoard
                gameBoard.selectedSegmentIndex = settingsModel!.board.rawValue
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
                
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
            }
        }
    }
    
    @IBAction func controlOpponent(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settingsModel?.gamePlayMode = .SinglePlayer
        case 1:
            settingsModel?.gamePlayMode = .MultiPlayer
        default:
            settingsModel?.gamePlayMode = .SinglePlayer
        }
        
        if isInitializedPlayMode {
            isInitializedGameBoard = true
            let alert = UIAlertController(title: "Game Play Mode", message: Constants.kPlayModeMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdatePlayMode(true)
                self.settingsModel?.setupGame = true
                
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
            if (EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode) {
                // Update level-of-difficulty
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(true, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                
                // Single player, thus game board must be 3x3!
                settingsModel?.board = .TTBoard
                gameBoard.selectedSegmentIndex = settingsModel!.board.rawValue
                
                // Single player, thus 4x4 board should be disabled
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                gameBoard.setEnabled(false, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
            } else {
                // Multiplayer mode, update level-of-difficulty
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
                
                // Multiplayer, thus 4x4 board should be enabled
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.TTBoard.rawValue)
                gameBoard.setEnabled(true, forSegmentAt: EnumGameBoard.FFBoard.rawValue)
            }
        }
    }

    @IBAction func controlGameBoard(_ sender: UISegmentedControl) {
        // Set previous board configuration to current
        settingsModel?.previousBoard = (settingsModel?.board)!
        
        // Now set board configuration to that selected
        switch sender.selectedSegmentIndex {
        case 0:
            settingsModel?.board = .TTBoard
        case 1:
            settingsModel?.board = .FFBoard
        default:
            break
        }

        if isInitializedGameBoard {
            let alert = UIAlertController(title: "Game Board", message: Constants.kGameBoardMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdateGameBoard(true)
                self.settingsModel?.setupGame = true
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
            if (EnumGameBoard.FFBoard == settingsModel!.board) {
                // 4x4 board, play mode is multiplayer!
                settingsModel?.gamePlayMode = .MultiPlayer
                opponent.selectedSegmentIndex = (settingsModel?.gamePlayMode.rawValue)!
                
                // 4x4 board, disable level-of-difficulty
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Easy.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Medium.rawValue)
                levelOfDifficulty.setEnabled(false, forSegmentAt: EnumLevelOfDifficulty.Hard.rawValue)
            } else {
                // 3x3 board, enable/disable level-of-difficulty accordingly
                settingsModel?.gamePlayMode = .SinglePlayer
                if (EnumPlayMode.SinglePlayer == settingsModel?.gamePlayMode) {
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

    // Set first move selection for model
    @IBAction func controlFirstMove(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settingsModel?.gameFirstMove = .Player
        case 1:
            settingsModel?.gameFirstMove = .Opponent
        default:
            settingsModel?.gameFirstMove = .Player
        }
    }

    // Set level-of-difficulty selection for model
    @IBAction func controlLevelOfDifficulty(_ sender: UISegmentedControl) {
        if isInitializedLevelOfDifficulty {
            let alert = UIAlertController(title: "Level of Difficulty", message: Constants.kLevelOfDifficultyMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {action in
                self.doUpdateLevelOfDifficulty(sender)
                self.settingsModel?.setupGame = true
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) {action in
            })
            present(alert, animated: true, completion: nil)
        } else {
            // Past initialization, from now on present alerts
            isInitializedLevelOfDifficulty = true
        }
    }
    
    func doUpdateLevelOfDifficulty(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.settingsModel?.difficulty = .Easy
        case 1:
            self.settingsModel?.difficulty = .Medium
        case 2:
            self.settingsModel?.difficulty = .Hard
        default:
            self.settingsModel?.difficulty = .Easy
        }
    }
    
}

