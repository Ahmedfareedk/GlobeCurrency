//
//  Country.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import Foundation

struct Country: Codable {
    let name: CountryName
    let currencies: [String: Currency]?
    let capital: [String]?
    let altSpellings: [String]?
    let region, subregion: String?
    let languages: [String: String]?
    let latlng: [Double]?
    let flag: String?
    let population: Int?
    let gini: [String: Double]?
    let fifa: String?
    let timezones, continents: [String]?
    let flags: Flags?
    let startOfWeek: String?
}

struct CountryName: Codable {
    let common, official: String?
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
