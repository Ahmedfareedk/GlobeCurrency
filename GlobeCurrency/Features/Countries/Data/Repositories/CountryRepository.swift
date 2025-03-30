//
//  CountryRepository.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

final class CountryRepository: CountryRepositoryContract {
    private let countryService: CountryServiceContract
    
    init(countryService: CountryServiceContract = CountryService()) {
        self.countryService = countryService
    }
    
    func save(country: Country) -> AnyPublisher<Void, any Error> {
        return countryService.save(country: country)
    }
    
    func fetchCountries() -> AnyPublisher<[Country], any Error> {
        return countryService.fetchCountries()
    }
    
    func delete(country: Country) -> AnyPublisher<Void, any Error> {
        return countryService.delete(country: country)
    }
}
