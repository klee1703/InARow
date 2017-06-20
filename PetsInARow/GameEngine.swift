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
            UIView.animate(withDuration: kDuration, delay: kDelay, options: [UIViewAnimationOptions.repeat, UIViewAnimationOptions.allowUserInteraction], animations: {
                cells[index].alpha = self.kAlpha
            }, completion: nil)
        }
    }
    
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
