//
//  RequestableContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

protocol RequestableContract {
    func request<T: Decodable>(_ urlRequest: RequestModel) -> AnyPublisher<T, Error>
}
