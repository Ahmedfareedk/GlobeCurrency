//
//  CountriesMainViewModel.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation
import Combine

class CountriesMainViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    private let permissionAuthenticator: PermissionsAuthenticatorContract
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    private let countriesPersistenceUseCase: CountryPersistenceUseCaseContract
    private let locationManager: UserLocationManager
    private var cancellables: Set<AnyCancellable> = []
    private var defaultCountryName: String = "Egypt"
 
    init(
        permissionAuthenticator: PermissionsAuthenticatorContract = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManager = UserLocationManager(),
        searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase(),
        countriesPersistenceUseCase: CountryPersistenceUseCaseContract = CountryPersistenceUseCase()
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countriesPersistenceUseCase = countriesPersistenceUseCase
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        permissionAuthenticator.requestAuthorizationStatus {[weak self] authorizationStatus in
            self?.getUserLocationBasedOnLocationPermission(isAuthorized: authorizationStatus == .authorized)
        }
    }
    
    private func getUserLocationBasedOnLocationPermission(isAuthorized: Bool) {
        if isAuthorized {
            setUserCountryName()
        } else {
            fetchAllCountries()
        }
    }
    
    private func setUserCountryName() {
        locationManager.requestLocation()
        locationManager.countryName
            .receive(on: RunLoop.main)
            .sink {[weak self] countryName in
                self?.defaultCountryName = countryName
                self?.fetchAllCountries()
            }.store(in: &cancellables)
    }
    
    private func fetchDefaultCountry() {
        isLoading = true
        searchCountriesUseCase.execute(countryName: defaultCountryName)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                self?.isLoading = false
                guard case .failure(_) = completion else { return }
            } receiveValue: {[weak self] countries in
                guard let self else { return }
                self.isLoading = false
                if let firstCountry = countries.first(where: {$0.name.common == self.defaultCountryName}) {
                    self.saveCountry(firstCountry)
                    fetchAllCountries()
                }
            }.store(in: &cancellables)
    }
    
    func removeCountry(_ country: Country) {
        self.isLoading = true
        countriesPersistenceUseCase.executeDelete(country:country)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                guard case .failure(_) = completion else { return }
                self?.isLoading = false
            } receiveValue: {[weak self] _ in
                self?.countries.removeAll(where: {$0 == country})
                self?.isLoading = false
            }.store(in: &cancellables)
    }
    
    func saveCountry(_ country: Country) {
        countriesPersistenceUseCase.executeSave(country: country)
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { _ in
                //TODO: to show a snack bar or a toast
            }
            .store(in: &cancellables)
    }
    
    func fetchAllCountries() {
        isLoading = true
        countriesPersistenceUseCase.executeFetchCountries()
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case .failure(_) = completion else { return }
                self.isLoading = false
            } receiveValue: {[weak self] countries in
                self?.isLoading = false
                self?.handleCountriesResponse(countries)
            }.store(in: &cancellables)
    }
    
    private func handleCountriesResponse(_ countries: [Country]) {
        guard !countries.isEmpty, countries.contains(where: {$0.name.common == defaultCountryName}) else {
            fetchDefaultCountry()
            return
        }
        self.countries = countries
    }
}
