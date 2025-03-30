//
//  CountryContentView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 30/03/2025.
//

import SwiftUI

struct CountryContentView: View {
    let country: Country
    
    var body: some View {
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
}
