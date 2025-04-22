//
//  NetworkParams.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation

typealias Parameters = [String: Any]
enum RequestParams {
    case pathParams(_: Parameters)
    case body(_: Parameters)
    case query(_: Parameters)
}
