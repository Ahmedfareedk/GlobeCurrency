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
        ImageLoaderView(imageURL: country.flags?.png ?? "")
        .frame(width: 80, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var detailsView: some View {
        CountryContentView(country: country)
    }
}
