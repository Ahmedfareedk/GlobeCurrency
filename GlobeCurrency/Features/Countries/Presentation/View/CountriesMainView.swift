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
    @State private var shouldRefreshData: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                countriesListView
            }
            .navigationTitle("Countries")
            .toolbar {
                if viewModel.isOnline {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: CountriesSearchView(shouldRefresh: $shouldRefreshData)) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .onChange(of: shouldRefreshData, { _, newValue in
            if newValue {
                viewModel.fetchAllCountries()
                shouldRefreshData = false
            }
        })
        .sheet(item: $selectedCountry) { country in
            detailsView(country: country)
                .presentationDetents([.medium, .large])
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            viewModel.checkLocationPermission()
        }
        .overlay(viewModel.isLoading ? LoadingView() : nil)
        .overlay(goOfflineSnackBarView)
    }
    
    
    private var countriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.countries, id: \.id) { country in
                    CountryCardView(country: country, actionButton: listItemActionButton(deletableCountry: country))
                        .onTapGesture {
                            self.selectedCountry = country
                        }
                }
            }
        }
        .padding()
    }
  
    @ViewBuilder
    private func detailsView(country: Country) -> some View {
        CountryDetailsView(country: country, actionButton: detailsActionButton(deletableCountry: country)) {
            dismissDetailsSheet()
        }
    }
    
    @ViewBuilder
    private func listItemActionButton(deletableCountry: Country) -> some View {
        CustomButton(foregroundColor: .red, imageName: "trash") {
            viewModel.removeCountry(deletableCountry)
        }
    }
    
    @ViewBuilder
    private func detailsActionButton(deletableCountry: Country) -> some View {
        CustomButton(backgroundColor: .red, label: "Remove from countries list", height: 64, cornerRadius: 12, isFullWidth: true) {
            viewModel.removeCountry(deletableCountry)
            dismissDetailsSheet()
        }
    }
    
    private var goOfflineSnackBarView: some View {
        SnackBarView(message: "You are offline, try to connect to fetch default country", dismissible: false, isVisible: Binding(
            get: { !viewModel.isOnline },
            set: { viewModel.isOnline = !$0 }
        ))
    }
    
    private func dismissDetailsSheet() {
        selectedCountry = nil
    }
}

#Preview {
    CountriesMainView()
}
