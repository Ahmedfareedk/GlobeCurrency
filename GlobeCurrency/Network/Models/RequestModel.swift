//
//  RequestModel.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation

struct RequestModel {
    let endpoint: EndPointsContract
    let body: Data?
    
    init(endpoint: EndPointsContract, body: Data? = nil) {
        self.endpoint = endpoint
        self.body = body
    }
    
    func getURLRequest() -> URLRequest? {
        guard let requestURL = endpoint.getURL() else {
            fatalError("Could not create URL: \(endpoint.baseURL)")
        }
        
        var request: URLRequest = URLRequest(url: requestURL)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
        
    }
}
