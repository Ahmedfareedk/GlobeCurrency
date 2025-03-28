//
//  EndPointsContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation


protocol EndPointsContract {
    var baseURL: String { get }
    var path: String { get }
    var params: [URLQueryItem] { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    
    func getURL() -> URL?
}


extension EndPointsContract {
    
    var baseURL: String {
        return NetworkConstants.baseURL
    }
    
    func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = path
        components.queryItems = params
        return components.url
    }
}



