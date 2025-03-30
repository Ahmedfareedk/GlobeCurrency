//
//  SearchCountriesServiceContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Combine

protocol SearchCountriesServiceContract {
    func searchCountries(for name: String) -> AnyPublisher<[Country], Error>
}
