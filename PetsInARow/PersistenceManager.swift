//
//  PersistenceManager.swift
//  PetsInARow
//
//  Created by Keith Lee on 6/7/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import Foundation

class PersistenceManager {
    let delegate: AppDelegate
    
    init(delegate: AppDelegate) {
        self.delegate = delegate
    }

    class func unarchive<T>(model: inout T, filePath: String, key: String) {
        if (FileManager.default.fileExists(atPath: filePath)) {
            let data = NSMutableData(contentsOfFile: filePath)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data! as Data)
            let unarchive = unarchiver.decodeObject(forKey: key) as? T
            unarchiver.finishDecoding()
            if let temp = unarchive {
                model = temp
            }
        } else {
            print ("FILE NOT FOUND")
        }
    }
    
    class func unarchiveStatistics(model: StatisticsModel, filePath: String, key: String) {
        if (FileManager.default.fileExists(atPath: filePath)) {
            let data = NSMutableData(contentsOfFile: filePath)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data! as Data)
            let unarchive = unarchiver.decodeObject(forKey: key) as? StatisticsModel
            unarchiver.finishDecoding()
            if let temp = unarchive {
                model.update(temp)
            }
        } else {
            print ("FILE NOT FOUND")
        }
    }

    class func archive<T>(model: T, filePath: String, key: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(model, forKey: key)
        archiver.finishEncoding()
        do {
            try data.write(toFile: filePath, options: .atomic)
        } catch {
            print(error)
        }
    }

}
