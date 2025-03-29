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
    var params: RequestParams? { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
}


extension EndPointsContract {
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var params: RequestParams? {
        return nil
    }
    
    var baseURL: String {
        return NetworkConstants.baseURL
    }
}



