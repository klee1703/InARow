//
//  BoardUIView.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/26/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

@IBDesignable
class BoardUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}
