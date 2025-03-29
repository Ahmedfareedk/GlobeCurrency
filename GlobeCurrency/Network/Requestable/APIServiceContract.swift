//
//  RequestableContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

protocol APIServiceContract {
    func request<T: Decodable>(_ urlRequest: RequestModel) -> AnyPublisher<T, Error>
}
