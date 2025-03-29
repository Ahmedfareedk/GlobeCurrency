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
    private let permissionAuthenticator: PermissionsAuthenticatorContract
    private let locationManager: UserLocationManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        permissionAuthenticator: PermissionsAuthenticatorContract = PermissionsAutheticator.locationPermission,
        locationManager: UserLocationManager = UserLocationManager()
    ) {
        self.permissionAuthenticator = permissionAuthenticator
        self.locationManager = locationManager
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
            .sink { countryName in
                print(countryName)
            }.store(in: &cancellables)
    }
    
    private func getDefaultCountry() {
        
    }
}
