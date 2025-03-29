//
//  CountryCardView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import SwiftUI

struct CountryCardView: View {
    let country: Country
    let onRemove: () -> Void
    var isRemovable: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            flagImageView
            detailsView
            
            if isRemovable {
                Spacer()
                removeButton
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cardBorder.opacity(0.5))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func detailText(_ text: String, isTitle: Bool = false) -> some View {
        Text(text)
            .font(isTitle ? .title2.bold() : .body)
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
    
    private var removeButton: some View {
        Button(action: onRemove) {
            Image(systemName: "trash")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.red.opacity(0.8))
                .clipShape(Circle())
        }
    }
}
