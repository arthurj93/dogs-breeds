//
//  Network.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import Alamofire

protocol handleErrorAPI {
    func handleError(_ error: Error)
    func validaFieldWithWebServiceErrors(_ error: Network.ErrorResponse.Item)
}

enum Network {
    enum Error: Swift.Error {
        case api(error: Swift.Error, response: ErrorResponse)
        case http(error: Swift.Error)
        case notConnectedToInternet
    }
}

extension Network {
    struct ErrorResponse: Decodable {
        let message: String
        let errors: [Item]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let message = try? container.decode(String.self, forKey: .message) {
                self.message = message
            } else {
                message = try container.decode(String.self, forKey: .Message)
            }
            
            errors = try container.decodeIfPresent([Item].self, forKey: .errors) ?? []
        }
    }
}


extension Network.ErrorResponse {
    struct Item: Decodable {
        let field: String
        let messages: [String]
    }
    
    private enum CodingKeys: String, CodingKey {
        case message
        case Message // tailor:disable
        case errors
    }
}


protocol NetworkingResource: URLRequestConvertible {
    static var baseURL: URL { get }
    
    var path: String { get }
    var method: HTTPMethod { get }
    var query: Parameters? { get }
    var body: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}


extension NetworkingResource {
    func asURLRequest() throws -> URLRequest {
        var url = Self.baseURL.appendingPathComponent(path)
        
        if let query = query {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
            urlComponents?.queryItems = queryItems
            
            if let newUrl = urlComponents?.url {
                url = newUrl
            }
        }
        
        let urlRequest = try URLRequest(url: url, method: method, headers: headers)
        return try encoding.encode(urlRequest, with: body)
    }
}

