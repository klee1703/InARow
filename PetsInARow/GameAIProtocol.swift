//
//  GameAIProtocol.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/17/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

protocol GameAIProtocol {
    func markCell(image: UIImage, settings: SettingsModel, statistics: StatisticsModel)
}
