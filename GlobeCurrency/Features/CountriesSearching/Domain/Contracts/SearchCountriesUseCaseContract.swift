//
//  SearchCountriesUseCaseContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

protocol SearchCountriesUseCaseContract {
    func execute(countryName: String) -> AnyPublisher<[Country], Error>
}
