//
//  RequestableContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

protocol APIServiceContract {
    func request<T: Decodable>(_ urlRequest: APIRequestBuilder, responseType: T.Type) -> AnyPublisher<T, Error>
}
