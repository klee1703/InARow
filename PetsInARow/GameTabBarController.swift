//
//  GameTabBarController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/25/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController {
    // Create a SettingsModel instance
    var settings = SettingsModel()
    var statistics = StatisticsModel()
    var game = GameModel()

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
