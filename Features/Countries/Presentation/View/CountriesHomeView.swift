//
//  CountriesHomeView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import SwiftUI

struct CountriesHomeView: View {
    @StateObject private var viewModel: CountriesHomeViewModel = .init()
    
    var body: some View {
        VStack {
            searchView
            Spacer()
        }
        .padding()
    }
    
    private var searchView: some View {
        SearchBarView(placeholder: "Search by country name"){ searchText in
            viewModel.searchCountries(for: searchText)
        }
    }
}

#Preview {
    CountriesHomeView()
}
