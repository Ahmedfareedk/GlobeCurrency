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
    @Published var showEmptyResultsState: Bool = false
    @Published var shouldRefreshFromCache: Bool = false
    @Published var showReachedLimitView: Bool = false
    @Published var isOnline: Bool = true
    private var cancellables = Set<AnyCancellable>()
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    private let countryPersistenceUseCase: CountryPersistenceUseCaseContract
    private let networkMonitor: NetworkMonitorContract
    
    init(
        searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase(),
        countryPersistenceUseCase: CountryPersistenceUseCaseContract = CountryPersistenceUseCase(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared
    ) {
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countryPersistenceUseCase = countryPersistenceUseCase
        self.networkMonitor = networkMonitor
        observeNetworkChanges()
    }
    
    
    private func observeNetworkChanges() {
        if let monitor = networkMonitor as? NetworkMonitor {
            monitor.$isConnected
                .receive(on: RunLoop.main)
                .dropFirst()
                .sink { [weak self] isConnected in
                    self?.isOnline = isConnected
                }
                .store(in: &cancellables)
        }
    }

    func searchCountries(for name: String) {
        guard !name.isEmpty else { return }
        isLoading = true
       showEmptyResultsState = false
        searchCountriesUseCase.execute(countryName: name)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                guard case .failure(_) = completion else { return }
                self?.isLoading = false
                self?.showEmptyResultsState = true
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
            } receiveValue: {[weak self] cachedCountries in
                guard let self else { return }
                let filteredCountries = countries.filter { !cachedCountries.contains($0) }
                guard !filteredCountries.isEmpty else {
                    showEmptyResultsState = true
                    return
                }
                self.countries = filteredCountries
            }.store(in: &cancellables)
    }
    
    func saveCountry(_ country: Country) {
        isLoading = true
        fetchAllCountries {[weak self] cachedCount in
            guard cachedCount < 5 else {
                self?.isLoading = false
                self?.showReachedLimitView = true
                return
            }
            guard let self else { return }
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
    
    private func fetchAllCountries(completion: @escaping (Int) -> Void) {
        countryPersistenceUseCase.executeFetchCountries()
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { countries in
                completion(countries.count)
            }.store(in: &cancellables)
    }
}
