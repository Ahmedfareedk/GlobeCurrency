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
    @Published var isOnline: Bool = true
    @Published var showOfflineSnackBar: Bool = false
    @Published private var locationPermissionStatus: AuthorizationStatus = .notDetermined
    private let permissionAuthenticator: PermissionsAuthenticatorContract
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    private let countriesPersistenceUseCase: CountryPersistenceUseCaseContract
    private let locationManager: UserLocationManager
    private let networkMonitor: NetworkMonitorContract
    private var cancellables: Set<AnyCancellable> = []
    private var defaultCountryName: String = "Egypt"
    
 
    init(
        permissionAuthenticator: PermissionsAuthenticatorContract = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManager = UserLocationManager(),
        searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase(),
        countriesPersistenceUseCase: CountryPersistenceUseCaseContract = CountryPersistenceUseCase(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
        self.searchCountriesUseCase = searchCountriesUseCase
        self.countriesPersistenceUseCase = countriesPersistenceUseCase
        self.networkMonitor = networkMonitor
        checkLocationPermission()
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
    
    func checkLocationPermission() {
        permissionAuthenticator.requestAuthorizationStatus {[weak self] authorizationStatus in
            self?.getUserLocationBasedOnLocationPermission(isAuthorized: authorizationStatus)
        }
    }
    
    private func getUserLocationBasedOnLocationPermission(isAuthorized: AuthorizationStatus) {
        guard locationPermissionStatus != isAuthorized else { return }
        locationPermissionStatus = isAuthorized
        if locationPermissionStatus == .authorized && isOnline {
            setUserCountryName()
        } else {
            fetchAllCountries()
        }
    }
    
    private func setUserCountryName() {
        isLoading = true
        locationManager.requestLocation()
        locationManager.countryName
            .receive(on: RunLoop.main)
            .sink {[weak self] countryName in
                self?.defaultCountryName = countryName
                self?.fetchAllCountries()
            }.store(in: &cancellables)
    }
    
    private func fetchDefaultCountry() {
        guard isOnline else {
            showOfflineSnackBar = true
            return
        }
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
        isLoading = true
        countriesPersistenceUseCase.executeSave(country: country)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                self?.isLoading = false
                guard case .failure(_) = completion else { return }
            } receiveValue: {[weak self] _ in
                self?.isLoading = false
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
                self?.handleCountriesResponse(countries)
                self?.isLoading = false
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
