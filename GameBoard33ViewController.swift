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
    @IBOutlet weak var cell0: UIButton!
    @IBOutlet weak var cell1: UIButton!
    @IBOutlet weak var cell2: UIButton!
    @IBOutlet weak var cell3: UIButton!
    @IBOutlet weak var cell4: UIButton!
    @IBOutlet weak var cell5: UIButton!
    @IBOutlet weak var cell6: UIButton!
    @IBOutlet weak var cell7: UIButton!
    @IBOutlet weak var cell8: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cellPressed(_ sender: UIButton) {
        print(sender.currentTitle! + " pressed!")
    }
    
    override func clearBoard() {
        // IMPLEMENT!
        print("Clearing 3x3 board")
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
