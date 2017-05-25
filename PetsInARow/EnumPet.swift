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
    case Owl = "Owl"
    case Giraffe = "Giraffe"
    case Elephant = "Elephant"
    case Pig = "Pig"
    case Shark = "Shark"
    
    static func values() -> [String] {
        return [Cat.rawValue, Dog.rawValue, Owl.rawValue, Giraffe.rawValue, Elephant.rawValue, Pig.rawValue, Shark.rawValue]
    }
}
