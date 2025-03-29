//
//  SearchCountriesService.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

final class SearchCountriesService: SearchCountriesServiceContract {
    
    private let apiService: APIServiceContract
    
    init(apiService: APIServiceContract = APIService()) {
        self.apiService = apiService
    }
    
    func searchCountries(for name: String) -> AnyPublisher<[Country], any Error> {
        let requestModel = APIRequestBuilder(endpoint: SearchCountriesEndPoints.searchCountry(name: name))
        return apiService.request(requestModel, responseType: [Country].self)
    }
    
    
}
