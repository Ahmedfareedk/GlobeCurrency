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
    @Published var shouldRefreshFromCache: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    private let countryPersistenceUseCase: CountryPersistenceUseCaseContract
    
    init(
        searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase(),
        countryPersistenceUseCase: CountryPersistenceUseCaseContract = CountryPersistenceUseCase()
    ) {
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countryPersistenceUseCase = countryPersistenceUseCase
    }
    
    func searchCountries(for name: String) {
        isLoading = true
        searchCountriesUseCase.execute(countryName: name)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                self?.isLoading = false
                guard case .failure(_) = completion else { return }
            } receiveValue: { [weak self] countries in
                self?.filterCountries(countries: countries)
                self?.isLoading = false
            }.store(in: &cancellables)
    }
    
    private func filterCountries(countries: [Country]) {
        countryPersistenceUseCase.executeFetchCountries()
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { cachedCountries in
                self.countries = countries.filter { !cachedCountries.contains($0) }
            }.store(in: &cancellables)
    }
    
    func saveCountry(_ country: Country) {
        isLoading = true
        countryPersistenceUseCase.executeSave(country: country)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                guard case .failure(_) = completion else { return }
                self?.isLoading = false
            } receiveValue: {[weak self] _ in
                self?.isLoading = false
                self?.countries.removeAll(where: {$0.id == country.id})
                self?.shouldRefreshFromCache = true
            }.store(in: &cancellables)

    }
}
