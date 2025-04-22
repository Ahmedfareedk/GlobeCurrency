//
//  NetworkError.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case invalidResponse
    case custom(error: String)
}
