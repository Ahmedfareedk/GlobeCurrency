//
//  SearchCountriesUseCase.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

final class SearchCountriesUseCase: SearchCountriesUseCaseContract {
    private let repository: SearchCountriesRepositoryContract
    
    init(repository: SearchCountriesRepositoryContract = SearchCountriesRepository()) {
        self.repository = repository
    }
    
    func execute(countryName: String) -> AnyPublisher<[Country], any Error> {
        return repository.searchCountries(for: countryName)
    }
    
    
}
