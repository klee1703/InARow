//
//  UICellButton.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/13/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class UICellButton: UIButton, CAAnimationDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var cellState = EnumCellState.None
    var animation = CABasicAnimation(keyPath: "opacity")

}
