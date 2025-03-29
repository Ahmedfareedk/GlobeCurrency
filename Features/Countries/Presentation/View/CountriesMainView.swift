//
//  CountriesMainView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import SwiftUI

struct CountriesMainView: View {
    @StateObject private var viewModel: CountriesMainViewModel = .init()
    @State private var selectedCountry: Country?

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.countries, id: \.id) { country in
                            CountryCardView(country: country, isRemovable: true) {
                                removeCountry(country)
                            }
                            .onTapGesture {
                                self.selectedCountry = country
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Selected Countries")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CountriesSearchView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $selectedCountry) { country in
            detailsView(country: country)
            .presentationDetents([.medium, .large])
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            viewModel.checkLocationPermission()
        }
        .overlay(viewModel.isLoading ? LoadingView() : nil)

        
    }
    
    @ViewBuilder
    private func detailsView(country: Country) -> some View {
        CountryDetailsView(country: country) {
            selectedCountry = nil
        }
    }
    
    private func removeCountry(_ country: Country) {
        viewModel.countries.removeAll { $0.id == country.id }
    }
}

#Preview {
    CountriesMainView()
}
