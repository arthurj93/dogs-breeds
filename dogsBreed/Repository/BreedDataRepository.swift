//
//  BreedDataRepository.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import RealmSwift

protocol BreedData {
    func save(name: String, images: [String])
    func getAllBreeds() -> [Breeds]
    func getBreedBy(name: String) -> Breeds
    func deleteBreed(name: String)
}

protocol BreedDataForVC {
    func save()
    func getAllBreeds() -> [Breeds]
    func deleteBreed()
    func getBreedByName() -> Breeds
}

class BreedDataImplementation: BreedData {
   
    private var realm: Realm
    
    private init(realm: Realm) {
        self.realm = realm
    }
    
    private static var shareBreedData: BreedDataImplementation = {
        let breedData = BreedDataImplementation(realm: try! Realm())
        return breedData
    }()
    
    class func shared() -> BreedDataImplementation {
        return shareBreedData
    }
    
    func save(name: String, images: [String]) {
        let breed = RMBreed(value: ["name" : name, "images": images])
        do {
            try realm.write {
                realm.add(breed, update: true)
            }
        } catch let realmErr{
            print(realmErr)
        }
    }
    
    func getAllBreeds() -> [Breeds] {
        let breeds = Array(realm.objects(RMBreed.self).sorted(byKeyPath: "name"))
        return BreedConverter.convertObjects(objs: breeds)
    }
    
    func getBreedBy(name: String) -> Breeds {
        let breed = realm.object(ofType: RMBreed.self, forPrimaryKey: name)
        if let unwrappedBreed = breed {
            return BreedConverter.convertObject(obj: unwrappedBreed)
        }
        return Breeds()
    }
    
    func deleteBreed(name: String) {
        do {
            try realm.write {
                let breedToDelete = realm.objects(RMBreed.self).filter("name = '\(name)'")
                realm.delete(breedToDelete)
            }
        } catch let realmErr{
            print(realmErr)
        }
    }
}
