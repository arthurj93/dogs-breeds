//
//  BreedConverter.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation

class BreedConverter {
    
    static func convertObject(obj: RMBreed) -> Breeds {
        
        let breed = Breeds(name: obj.name,
                           images: Array(obj.images))
        
        return breed
    }
    
    static func convertObjects(objs: [RMBreed]) -> [Breeds] {
        
        var breeds = [Breeds]()
        
        for obj in objs {
            breeds.append(convertObject(obj: obj))
        }
        return breeds
    }
}
