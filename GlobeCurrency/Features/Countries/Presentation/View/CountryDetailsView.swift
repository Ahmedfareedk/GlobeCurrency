//
//  CountryDetailsView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import SwiftUI

import SwiftUI

struct CountryDetailsView<ActionButton: View>: View {
    let country: Country
    var actionButton: ActionButton
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            closeButton
            flagImageView
            detailsTextViews
            Spacer()
            actionButton
        }
        .padding()
    }
    
    private var flagImageView: some View {
        AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
        } placeholder: {
            ProgressView()
        }
    }
    
    private var detailsTextViews: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(country.name.common)
                .font(.title2.bold())
            
            if let capital = country.capital?.first {
                Text("Capital: \(capital)")
            }
            
            if let currency = country.currencies?.values.first {
                Text("Currency: \(currency.name ?? "")")
                if let symbol = currency.symbol {
                    Text("Symbol: \(symbol)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var closeButton: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.gray.opacity(0.6))
                    .clipShape(Circle())
            }
        }
    }
}
