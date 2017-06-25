//
//  GameEngine.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/18/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class GameEngine {
    // Constants
    let kDuration = 0.6
    let kDelay = 0.0
    let kAlpha: CGFloat = 0.0
    
    var settings: SettingsModel
    var statistics: StatisticsModel
    
    var animation: CABasicAnimation

    init(settings: SettingsModel, statistics: StatisticsModel) {
        self.settings = settings
        self.statistics = statistics
        
        self.animation = CABasicAnimation(keyPath: "opaque")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.timingFunction = timingFunction
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
    }
    
    func isTTTHorizontalMatch(cells: [UICellButton], range: CountableClosedRange<Int>, cellState: EnumCellState) -> Bool {
        // Compare for range and return false if not matched
        for index in range {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    func isTTTStepMatch(cells: [UICellButton], initialValue: Int, max: Int, step: Int, cellState: EnumCellState) -> Bool {
        for index in stride(from: initialValue, to: max+1, by: step) {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    func isTTTValuesMatch(cells: [UICellButton], values: [Int], cellState: EnumCellState) -> Bool {
        for index in values {
            if cells[index].cellState != cellState {
                return false
            }
        }
        return true
    }

    // Animate the buttons
    func animateButtons(cells: [UICellButton], range: CountableClosedRange<Int>) {
        for index in range {
            UIView.animate(withDuration: kDuration, delay: kDelay, options: [.repeat, .allowUserInteraction, .autoreverse], animations: {
                cells[index].alpha = self.kAlpha
            }, completion: nil)
        }
    }
/*
    func animateButtons(cells: [UICellButton], range: CountableClosedRange<Int>) {
        for index in range {
     
            UIView.animate(withDuration: kDuration, delay: kDelay, options: [UIViewAnimationOptions.repeat, UIViewAnimationOptions.allowUserInteraction], animations: {
                cells[index].alpha = self.kAlpha
            }, completion: nil)
 
            cells[index].layer.add(animation, forKey: "opaque")
        }
    }
*/ 
    
    func animateButtons(cells: [UICellButton], initialValue: Int, max: Int, step: Int) {
        for index in stride(from: initialValue, to: max+1, by: step) {
            UIView.animate(withDuration: kDuration, delay: kDelay, options: UIViewAnimationOptions.repeat, animations: {
                cells[index].alpha = self.kAlpha
            }, completion: nil)
        }
    }
    
    func animateButtons(cells: [UICellButton], values: [Int]) {
        for index in values {
            UIView.animate(withDuration: kDuration, delay: kDelay, options: UIViewAnimationOptions.repeat, animations: {
                cells[index].alpha = self.kAlpha
            }, completion: nil)
        }
    }
}
