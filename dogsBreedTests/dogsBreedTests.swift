//
//  dogsBreedTests.swift
//  dogsBreedTests
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import XCTest
import RealmSwift
@testable import dogsBreed


class dogsBreedTests: XCTestCase {
    
    
    let realm = try! Realm()
    let breedRealm = BreedDataImplementation.shared()

    override func setUp() {
        
        try! realm.write {
            realm.deleteAll()
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDBCleanGetAll() {
        
        let breeds = breedRealm.getAllBreeds()
        
        
        XCTAssertEqual(breeds.count, 0)
    }
    
    func testBreedSave() {
        
        let breedMock = Breeds(name: "breed1", images: ["image1"])
        
        breedRealm.save(name: breedMock.name ?? "", images: breedMock.images ?? [""])
        
        let savedBreed = breedRealm.getBreedBy(name: breedMock.name ?? "")
        
        XCTAssertEqual(breedMock.name, savedBreed.name)
        
    }
    
    func testBreedGetAll() {
        let breedMock1 = Breeds(name: "breed1", images: ["image1"])
        let breedMock2 = Breeds(name: "breed2", images: ["image2"])
        let breedMock3 = Breeds(name: "breed3", images: ["image3"])
        
        breedRealm.save(name: breedMock1.name ?? "", images: breedMock1.images ?? [""])
        breedRealm.save(name: breedMock2.name ?? "", images: breedMock2.images ?? [""])
        breedRealm.save(name: breedMock3.name ?? "", images: breedMock3.images ?? [""])
        
        let breedsSaved = breedRealm.getAllBreeds()
        
        XCTAssertEqual(breedsSaved.count, 3)
    }
    
    func testDeleteBreed() {
        let breedMock = Breeds(name: "breed1", images: ["image1"])
        
        breedRealm.save(name: breedMock.name ?? "", images: breedMock.images ?? [""])
        
        breedRealm.deleteBreed(name: breedMock.name ?? "")
        
        let breedsSaved = breedRealm.getAllBreeds()
        
        XCTAssertEqual(breedsSaved.count, 0)
        
    }

}
