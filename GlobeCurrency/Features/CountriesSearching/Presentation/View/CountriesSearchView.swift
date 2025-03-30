//
//  CountriesHomeView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import SwiftUI

struct CountriesSearchView: View {
    @StateObject private var viewModel: CountriesSearchViewModel = .init()
    @State private var searchText: String = ""
    @State private var selectedCountry: Country?
    @Binding var shouldRefresh: Bool
    
    var body: some View {
        VStack(spacing: 12){
            searchView
            countriesListView
        }
        .padding()
        .overlay(viewModel.isLoading ? LoadingView() : nil)
        .overlay((viewModel.showEmptyResultsState && !searchText.isEmpty) ? emptySearchResultsView : nil)
        .overlay(searchText.isEmpty ? emptySearchTextView : nil)
        .overlay(reachedLimitSnackBarView)
        .overlay(goOfflineSnackBarView)
        .sheet(item: $selectedCountry) { country in
            detailsView(country: country)
            .presentationDetents([.medium, .large])
        }
        .onChange(of: viewModel.shouldRefreshFromCache) { _, newValue in
            if newValue {
                self.shouldRefresh = newValue
                viewModel.shouldRefreshFromCache = false
            }
        }
    }
    
    @ViewBuilder
    private func detailsView(country: Country) -> some View {
        CountryDetailsView(country: country, actionButton: detailsActionButton) {
            dismissDetailsSheet()
        }
    }
    
    private var searchView: some View {
        SearchBarView(searchText: $searchText, isSearchButtonDisabled: !viewModel.isOnline, placeholder: "Search by country name") {
            dismissDetailsSheet()
            viewModel.searchCountries(for: searchText)
        }
        .disabled(!viewModel.isOnline)
    }
    
    private var countriesListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.countries, id: \.id) { country in
                    CountryCardView(country: country, actionButton: listItemActionButton(savableCountry: country))
                    .onTapGesture {
                        selectedCountry = country
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    private func dismissDetailsSheet() {
        selectedCountry = nil
    }
    
    private var emptySearchTextView: some View {
        EmptyStateView(
            message: "Start typing to search for a country",
            systemImage: "magnifyingglass")
    }
    
    private var emptySearchResultsView: some View {
        EmptyStateView(
            message: "No results found",
            systemImage: "exclamationmark.magnifyingglass")
    }
    
    @ViewBuilder
    private func listItemActionButton(savableCountry: Country) -> some View {
        CustomButton(foregroundColor: .blue, imageName: "plus.circle.fill") {
            viewModel.saveCountry(savableCountry)
        }
    }
    
    private var detailsActionButton: some View {
        CustomButton(backgroundColor: .blue, label: "Add to main countries list", height: 64, cornerRadius: 12, isFullWidth: true) {
            guard let selectedCountry else { return }
            viewModel.saveCountry(selectedCountry)
            dismissDetailsSheet()
        }
    }
    
    private var reachedLimitSnackBarView: some View {
        SnackBarView(message: "You can only save up to 5 countries.", isVisible: $viewModel.showReachedLimitView)
    }
    
    private var goOfflineSnackBarView: some View {
        SnackBarView(message: "You are offline, try to reconnect to fetch countries", dismissible: false, isVisible: Binding(
            get: { !viewModel.isOnline },
            set: { viewModel.isOnline = !$0 }
        ))
    }
}
