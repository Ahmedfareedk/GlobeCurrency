//
//  CountryCardView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import SwiftUI

struct CountryCardView<ActionButton: View>: View {
    let country: Country
    var actionButton: ActionButton
    
    var body: some View {
        HStack(spacing: 12) {
            flagImageView
            detailsView
            Spacer()
            actionButton
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cardBorder.opacity(0.5))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func detailText(_ text: String, isTitle: Bool = false) -> some View {
        Text(text)
            .font(isTitle ? .title2.bold() : .callout)
            .foregroundColor(.white.opacity(isTitle ? 1 : 0.8))
            .multilineTextAlignment(.leading)
    }
    
    private var flagImageView: some View {
        AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 80, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            detailText(country.name.common, isTitle: true)
            
            if let capital = country.capital?.first {
                detailText("Capital: \(capital)")
            }
            
            if let currency = country.currencies?.values.first {
                detailText("Currency: \(currency.name ?? "")")
                
                if let symbol = currency.symbol {
                    detailText("Symbol: ( \(symbol) )")
                    
                }
            }
        }
    }
}
