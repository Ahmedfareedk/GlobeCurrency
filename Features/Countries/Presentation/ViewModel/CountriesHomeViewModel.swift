//
//  CountriesHomeViewModel.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation
import Combine

final class CountriesHomeViewModel: ObservableObject {
    @Published var countries: [Country] = []
    private var cancellables = Set<AnyCancellable>()
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    
    init(searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase()) {
        self.searchCountriesUseCase = searchCountriesUseCase
    }
    
    func searchCountries(for name: String) {
        searchCountriesUseCase.execute(countryName: "egypt")
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error)
                
            } receiveValue: { countries in
                self.countries = countries
            }.store(in: &cancellables)

    }
}
