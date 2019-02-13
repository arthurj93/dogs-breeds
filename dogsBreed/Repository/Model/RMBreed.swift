//
//  RMBreed.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import RealmSwift

class RMBreed: Object {
    @objc dynamic var name = ""
    let images = List<String>()
    
    override class func primaryKey() -> String? {
        return "name"
    }
}

