//
//  RequestModel.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation

class APIRequestBuilder {
    let endpoint: EndPointsContract
    private var urlRequest: URLRequest

    init(endpoint: EndPointsContract) {
        self.endpoint = endpoint
        initURLRequest()
    }
    
    private func initURLRequest() {
        if let url = URL(string: endpoint.baseURL) {
            self.urlRequest = URLRequest(url: url)
        }
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
        
        setParameterIfExist(to: &request)
        
        return request
        
    }
    
    private func setParameterIfExist(to request: inout URLRequest) {
        if let params = endpoint.params {
            switch params {
            case .query(let parameters):
                applyQueryParameters(to: &request, with: parameters)
            case .body(let parameters):
                applyBodyParameters(to: &request, with: parameters)
            }
        }

    }
    private func applyQueryParameters(to request: inout URLRequest, with params: Parameters) {
        
        let queryParams = params.map { pair in
            return URLQueryItem(name: pair.key, value: "\(pair.value)")
        }

        if let url = request.url {
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
        }
    }
    
    private func applyBodyParameters(to request: inout URLRequest, with params: Parameters) {
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error encoding body parameters: \(error)")
        }
    }
}
