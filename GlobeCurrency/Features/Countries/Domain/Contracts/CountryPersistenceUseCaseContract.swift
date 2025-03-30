//
//  CountryPersistenceUseCaseContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

protocol CountryPersistenceUseCaseContract {
    func executeSave(country: Country) -> AnyPublisher<Void, Error>
    func executeFetchCountries() -> AnyPublisher<[Country], Error>
    func executeDelete(country: Country) -> AnyPublisher<Void, Error>
}
