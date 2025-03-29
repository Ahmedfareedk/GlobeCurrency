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
    private let locationManager: UserLocationManager
    private var cancellables: Set<AnyCancellable> = []
    private var defaultCountryName: String = "Egypt"
    private let searchCountriesUseCase: SearchCountriesUseCaseContract
    
    init(
        permissionAuthenticator: PermissionsAuthenticatorContract = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManager = UserLocationManager(),
        searchCountriesUseCase: SearchCountriesUseCaseContract = SearchCountriesUseCase()
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
        self.searchCountriesUseCase = searchCountriesUseCase
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        permissionAuthenticator.requestAuthorizationStatus {[weak self] authorizationStatus in
            self?.getUserLocationBasedOnLocationPermission(isAuthorized: authorizationStatus == .authorized)
        }
    }
    
    private func getUserLocationBasedOnLocationPermission(isAuthorized: Bool) {
        isAuthorized ? getCountryWithName() : getDefaultCountry()
    }
    
    private func getCountryWithName() {
        locationManager.requestLocation()
        locationManager.countryName
            .receive(on: RunLoop.main)
            .sink {[weak self] countryName in
                self?.defaultCountryName = countryName
                self?.fetchCountry()
            }.store(in: &cancellables)
    }
    
    private func getDefaultCountry() {
        fetchCountry()
    }
    
    private func fetchCountry() {
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
                    self.countries.insert(firstCountry, at: 0)
                }
            }.store(in: &cancellables)
    }
}
