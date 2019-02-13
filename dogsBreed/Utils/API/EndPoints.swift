//
//  EndPoints.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import Alamofire

struct Endpoint: NetworkingResource {
    
    static var baseURL: URL { return API.baseURL }
    
    let path: String
    let method: HTTPMethod
    let body: Parameters?
    let query: Parameters?
    let encoding: ParameterEncoding
    let headers: HTTPHeaders?
    
    init(path: String,
         method: HTTPMethod = .get,
         body: Parameters? = nil,
         query: Parameters? = nil,
         headers: HTTPHeaders? = nil,
         encoding: ParameterEncoding = URLEncoding.default) {
        self.path = path
        self.method = method
        self.body = body
        self.query = query
        self.headers = headers
        self.encoding = encoding
    }
    
}

enum API {
    static let baseURL = URL(string: "https://hidden-crag-71735.herokuapp.com/api")!
    
    enum Breed {
        
        static func getBreeds() -> NetworkingResource {
            return Endpoint(path: "/breeds",
                            method: .get,
                            encoding: JSONEncoding.default)
        }
        
        static func getImages(breed: String) -> NetworkingResource {
            return Endpoint(path: "\(breed)/images",
                            method: .get,
                            encoding: JSONEncoding.default)
        }
        
    }
}

