//
//  CountryService.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

final class CountryService: CountryServiceContract {
    private let cachingManager: FileCacheManagerContract
    
    init(cachingManager: FileCacheManagerContract = FileCacheManager(fileName: Constants.cachingFileName)) {
        self.cachingManager = cachingManager
    }
    
    func save(country: Country) -> AnyPublisher<Void, any Error> {
        return cachingManager.save(country)
    }
    
    func fetchCountries() -> AnyPublisher<[Country], any Error> {
        return cachingManager.fetchAll()
    }
    
    func delete(country: Country) -> AnyPublisher<Void, any Error> {
        return cachingManager.delete(country)
    }
    
    
}
