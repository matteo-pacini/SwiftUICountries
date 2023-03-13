import Foundation

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

    let favorite: Bool

}

// MARK: - Decodable + Equatable

extension Country: Decodable, Equatable {

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(.name)
        topLevelDomains = try container.decodeIfPresent(.topLevelDomains)
        cca2 = try container.decode(.cca2)
        ccn3 =  try container.decodeIfPresent(.ccn3)
        cca3 = try container.decode(.cca3)
        cioc = try container.decodeIfPresent(.cioc)
        independent = try container.decodeIfPresent(.independent)
        status = try container.decode(.status)
        unMember = try container.decode(.unMember)
        currencies = try container.decodeIfPresent(.currencies)
        internationalDirectDialing = try container.decode(.internationalDirectDialing)
        capital = try container.decodeIfPresent(.capital)
        altSpellings = try container.decode(.altSpellings)
        region = try container.decode(.region)
        subregion = try container.decodeIfPresent(.subregion)
        languages = try container.decodeIfPresent(.languages)
        translations = try container.decode(.translations)
        latitudeAndLongitude = try container.decode(.latitudeAndLongitude)
        landlocked = try container.decode(.landlocked)
        borders = try container.decodeIfPresent(.borders)
        area = try container.decode(.area)
        demonyms = try container.decodeIfPresent(.demonyms)
        flag = try container.decode(.flag)
        maps = try container.decode(.maps)
        population = try container.decode(.population)
        giniCoefficient = try container.decodeIfPresent(.giniCoefficient)
        fifa = try container.decodeIfPresent(.fifa)
        car = try container.decode(.car)
        timezones = try container.decode(.timezones)
        continents = try container.decode(.continents)
        flags = try container.decode(.flags)
        coatOfArms = try container.decode(.coatOfArms)
        startOfWeek = try container.decode(.startOfWeek)
        capitalInfo = try container.decode(.capitalInfo)
        postalCode = try container.decodeIfPresent(.postalCode)
        favorite = false
    }

}

extension Country.Demonym: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case female = "f"
        case male = "m"
    }

}

extension Country.CapitalInfo: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case latitudeAndLongitude = "latlng"
    }

}

extension Country.Name: Decodable, Equatable { }
extension Country.Currency: Decodable, Equatable { }
extension Country.InternationalDirectDialing: Decodable, Equatable { }
extension Country.Translation: Decodable, Equatable { }
extension Country.Maps: Decodable, Equatable { }
extension Country.Car: Decodable, Equatable { }
extension Country.Images: Decodable, Equatable { }
extension Country.PostalCode: Decodable, Equatable { }

// MARK: - Identifiable

extension Country: Identifiable {

    var id: String { name.common }

}
