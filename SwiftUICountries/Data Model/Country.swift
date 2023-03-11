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

    struct InternationalDirectDialing {
        let root: String?
        let suffixes: [String]?
    }

    struct Translation {
        let official: String
        let common: String
    }

    struct Demonym {
        let female: String
        let male: String
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
        let latitudeAndLongitude: [Double]?
    }

    struct PostalCode {
        let format: String
        let regex: String?
    }

    let name: Name
    let topLevelDomains: [String]?
    let cca2: String
    let ccn3: String?
    let cca3: String
    let cioc: String?
    let independent: Bool?
    let status: String
    let unMember: Bool
    let currencies: [String: Currency]?
    let internationalDirectDialing: InternationalDirectDialing
    let capital: [String]?
    let altSpellings: [String]
    let region: String
    let subregion: String?
    let languages: [String: String]?
    let translations: [String: Translation]
    let latitudeAndLongitude: [Double]
    let landlocked: Bool
    let borders: [String]?
    let area: Double
    let demonyms: [String: Demonym]?
    let flag: String
    let maps: Maps
    let population: Int
    let giniCoefficient: [String: Double]?
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

extension Country: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case name
        case topLevelDomains = "tld"
        case cca2
        case ccn3
        case cca3
        case cioc
        case independent
        case status
        case unMember
        case currencies
        case internationalDirectDialing = "idd"
        case capital
        case altSpellings
        case region
        case subregion
        case languages
        case translations
        case latitudeAndLongitude = "latlng"
        case landlocked
        case borders
        case area
        case demonyms
        case flag
        case maps
        case population
        case giniCoefficient
        case fifa
        case car
        case timezones
        case continents
        case flags
        case coatOfArms
        case startOfWeek
        case capitalInfo
        case postalCode
    }

}

extension Country.Demonym: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case female = "f"
        case male = "m"
    }

}

extension Country.CapitalInfo: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case latitudeAndLongitude = "latlng"
    }

}

extension Country.Name: Codable, Equatable { }
extension Country.Currency: Codable, Equatable { }
extension Country.InternationalDirectDialing: Codable, Equatable { }
extension Country.Translation: Codable, Equatable { }
extension Country.Maps: Codable, Equatable { }
extension Country.Car: Codable, Equatable { }
extension Country.Images: Codable, Equatable { }
extension Country.PostalCode: Codable, Equatable { }

// MARK: - Identifiable

extension Country: Identifiable {

    var id: String { name.common }

}
