//
//  Manager.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import Alamofire

extension JSONDecoder {
    static let iso8601: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
}

extension JSONEncoder {
    static let iso8601: JSONEncoder = {
        let decoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateEncodingStrategy = .formatted(formatter)
        return decoder
    }()
}

class APIManager {
    
    private let sessionManager: SessionManager
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: SessionManager())
        
        return apiManager
    }()
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    private init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func request<T: Codable>(_ resource: NetworkingResource, handler: @escaping (T?, _ error: Error?) ->()) {
        print("====REQUEST====\n")
        print(resource)
        
        self.sessionManager.request(resource)
            .validate()
            .responseData(completionHandler: { data in
                print("====RESPONSE====\n")
                print(data)
                print("====END====\n")
                
                switch data.result {
                case let .success(value):
                    print(value)
                    
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: value)
                        handler(obj, nil)
                    } catch let jsonErr {
                        handler(nil, jsonErr)
                    }

                case let .failure(error):
                    if let data = data.data,
                        let errorResponse = try? JSONDecoder().decode(Network.ErrorResponse.self, from: data) {
                        handler(nil, Network.Error.api(error: error, response: errorResponse))
                    } else if let error = error as? URLError, error.code == .notConnectedToInternet {
                        handler(nil, Network.Error.notConnectedToInternet)
                    } else {
                        handler(nil, Network.Error.http(error: error))
                    }
                    
                }
                
            })
    }
    
    
}
