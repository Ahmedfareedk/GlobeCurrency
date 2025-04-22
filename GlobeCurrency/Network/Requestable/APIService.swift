//
//  Requestable.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation
import Combine

final class APIService: APIServiceContract {
    func request<T: Decodable>(_ urlRequest: APIRequestBuilder, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let generatedURLRequest = urlRequest.getURLRequest()
        else { fatalError("Couldn't Create URLRequest")
        }
        
        return URLSession.shared.dataTaskPublisher(for: generatedURLRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (NetworkConstants.statusCodeSuccessRange).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: responseType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
