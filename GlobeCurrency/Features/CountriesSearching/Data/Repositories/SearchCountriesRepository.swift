//
//  SearchCountriesRepository.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation
import Combine

final class SearchCountriesRepository: SearchCountriesRepositoryContract {
    
    private let service: SearchCountriesServiceContract
    
    init(service: SearchCountriesServiceContract = SearchCountriesService()) {
        self.service = service
    }
    
    func searchCountries(for name: String) -> AnyPublisher<[Country], any Error> {
        return service.searchCountries(for: name)
    }
}
