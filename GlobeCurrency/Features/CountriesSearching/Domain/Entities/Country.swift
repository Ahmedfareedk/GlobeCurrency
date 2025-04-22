//
//  Country.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    let name: CountryName
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String?
    let languages: [String: String]?
    let latlng: [Double]?
    let flag: String?
    let population: Int?
    let gini: [String: Double]?
    let flags: Flags?
    let cca3: String?
    
    var id: String {
        cca3 ?? UUID().uuidString
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
           return lhs.id == rhs.id
       }
}

struct CountryName: Codable {
    let common, official: String
    let nativeName: [String: NativeName]?
}

struct NativeName: Codable {
    let official, common: String?
}

struct Currency: Codable {
    let name, symbol: String?
}

struct Flags: Codable {
    let png, svg, alt: String?
}
