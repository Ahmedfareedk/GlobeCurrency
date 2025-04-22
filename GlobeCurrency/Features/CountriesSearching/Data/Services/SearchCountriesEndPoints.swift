//
//  SearchCountriesEndPoints.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation

enum SearchCountriesEndPoints: EndPointsContract {
    case searchCountry(name: String)
    
    var path: String {
        return NetworkConstants.searchByNamePath
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: RequestParams? {
        switch self {
        case .searchCountry(let name):
            return .pathParams(["name": name])
        }
    }
    
}
