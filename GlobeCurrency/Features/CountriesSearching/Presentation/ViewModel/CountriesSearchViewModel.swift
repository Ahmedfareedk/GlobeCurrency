//
//  CountriesHomeViewModel.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation
import Combine

final class CountriesSearchViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    
    init(searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase()) {
        self.searchCountriesUseCase = searchCountriesUseCase
    }
    
    func searchCountries(for name: String) {
        isLoading = true
        searchCountriesUseCase.execute(countryName: name)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                self?.isLoading = false
                guard case .failure(let error) = completion else { return }
                print(error)
                
            } receiveValue: { [weak self]countries in
                self?.isLoading = false
                self?.countries = countries
            }.store(in: &cancellables)

    }
}
