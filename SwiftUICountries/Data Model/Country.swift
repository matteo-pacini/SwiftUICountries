//
//  Country.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 08/03/2023.
//

import Foundation

// MARK: - Model

struct Country {

    struct Name {
        let common: String
        let official: String
        let nativeName: [String: Name]?
    }

    struct Currency {
        let name: String
        let symbol: String?
    }

    struct Idd {
        let root: String?
        let suffixes: [String]?
    }

    struct Translation {
        let official: String
        let common: String
    }

    struct Denonym {
        let f: String
        let m: String
    }

    struct Maps {
        let googleMaps: URL
        let openStreetMaps: URL
    }

    struct Car {
        let signs: [String]?
        let side: String
    }

    struct Images  {
        let png: URL?
        let svg: URL?
        let alt: String?
    }

    struct CapitalInfo  {
        let latlng: [Double]?
    }

    struct PostalCode {
        let format: String
        let regex: String?
    }

    let name: Name
    let tld: [String]?
    let cca2: String
    let ccn3: String?
    let cca3: String
    let cioc: String?
    let independent: Bool?
    let status: String
    let unMember: Bool
    let currencies: [String: Currency]?
    let idd: Idd
    let capital: [String]?
    let altSpellings: [String]
    let region: String
    let subregion: String?
    let languages: [String: String]?
    let translations: [String: Translation]
    let latlng: [Double]
    let landlocked: Bool
    let borders: [String]?
    let area: Double
    let denonyms: [String: Denonym]?
    let flag: String
    let maps: Maps
    let population: Int
    let gini: [String: Double]?
    let fifa: String?
    let car: Car
    let timezones: [String]
    let continents: [String]
    let flags: Images
    let coatOfArms: Images
    let startOfWeek: String
    let capitalInfo: CapitalInfo
    let postalCode: PostalCode?

}

// MARK: - Codable + Equatable

extension Country: Codable, Equatable { }
extension Country.Name: Codable, Equatable { }
extension Country.Currency: Codable, Equatable { }
extension Country.Idd: Codable, Equatable { }
extension Country.Translation: Codable, Equatable { }
extension Country.Denonym: Codable, Equatable { }
extension Country.Maps: Codable, Equatable { }
extension Country.Car: Codable, Equatable { }
extension Country.Images: Codable, Equatable { }
extension Country.CapitalInfo: Codable, Equatable { }
extension Country.PostalCode: Codable, Equatable { }

// MARK: - Identifiable

extension Country: Identifiable {

    var id: String { name.common }

}
