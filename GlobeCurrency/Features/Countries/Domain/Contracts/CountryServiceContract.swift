//
//  CountryServiceContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

protocol CountryServiceContract {
    func save(country: Country) -> AnyPublisher<Void, Error>
    func fetchCountries() -> AnyPublisher<[Country], Error>
    func delete(country: Country) -> AnyPublisher<Void, Error>
}
