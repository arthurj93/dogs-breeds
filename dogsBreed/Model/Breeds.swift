//
//  Breeds.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation

struct Breeds {
    let name: String?
    let images: [String]?
    
    init(name: String? = nil,
         images: [String]? = nil) {
        
        self.name = name
        self.images = images
    }
}
