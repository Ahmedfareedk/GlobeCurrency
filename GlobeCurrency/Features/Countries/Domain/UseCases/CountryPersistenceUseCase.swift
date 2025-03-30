//
//  CountryPersistenceUseCase.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

final class CountryPersistenceUseCase: CountryPersistenceUseCaseContract {
    private let countryRepository: CountryRepositoryContract
    
    init(countryRepository: CountryRepositoryContract = CountryRepository()) {
        self.countryRepository = countryRepository
    }
    
    func executeSave(country: Country) -> AnyPublisher<Void, any Error> {
        return countryRepository.save(country: country)
    }
    
    func executeFetchCountries() -> AnyPublisher<[Country], any Error> {
        return countryRepository.fetchCountries()
    }
    
    func executeDelete(country: Country) -> AnyPublisher<Void, any Error> {
        return countryRepository.delete(country: country)
    }
    
    
}
