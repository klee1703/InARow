//
//  Pets.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/11/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

enum EnumPet: String {
    case Cat = "Cat"
    case Dog = "Dog"
    case Crocodile = "Crocodile"
    case Owl = "Owl"
    case Giraffe = "Giraffe"
    case Elephant = "Elephant"
    case Penguin = "Penguin"
    case Tiger = "Tiger"
    case Cyclops = "Cyclops"
    
    static func values() -> [String] {
        return [Cat.rawValue, Dog.rawValue, Owl.rawValue, Giraffe.rawValue, Elephant.rawValue, Crocodile.rawValue, Tiger.rawValue, Penguin.rawValue, Cyclops.rawValue]
    }
}
