//
//  SearchCountriesRepositoryContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

protocol SearchCountriesRepositoryContract {
    func searchCountries(for name: String) -> AnyPublisher<[Country], Error>
}
