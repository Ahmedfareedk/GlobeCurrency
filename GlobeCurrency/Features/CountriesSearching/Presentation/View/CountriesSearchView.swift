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
    
    var body: some View {
        VStack(spacing: 12){
            searchView
            Spacer()
            if searchText.isEmpty {
                emptySearchTextView
            }
            
            if viewModel.countries.isEmpty && !searchText.isEmpty{
                emptySearchResultsView
            }
            
            countriesListView
        }
        .padding()
        .overlay(viewModel.isLoading ? LoadingView() : nil)
        .sheet(item: $selectedCountry) { country in
            detailsView(country: country)
            .presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder
    private func detailsView(country: Country) -> some View {
        CountryDetailsView(country: country, actionButton: detailsActionButton) {
            selectedCountry = nil
        }
    }
    
    private var searchView: some View {
        SearchBarView(searchText: $searchText, placeholder: "Search by country name") {
            viewModel.searchCountries(for: searchText)
        }
    }
    
    private var countriesListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.countries, id: \.id) { country in
                    CountryCardView(country: country, actionButton: listItemActionButton)
                    .onTapGesture {
                        selectedCountry = country
                    }
                }
            }
        }
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
    
    private var listItemActionButton: some View {
        CustomButton(foregroundColor: .blue, imageName: "plus.circle.fill") {
            print("addddd")
        }
    }
    
    private var detailsActionButton: some View {
        CustomButton(backgroundColor: .blue, label: "Add to main countries list", height: 64, cornerRadius: 12, isFullWidth: true) {
            print("addddd")
        }
    }
}

#Preview {
    CountriesSearchView()
}
