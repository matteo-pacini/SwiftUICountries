import RealmSwift
import Foundation

// MARK: - Embedded Objects

final class RealmName: EmbeddedObject {
    @Persisted var common: String = ""
    @Persisted var official: String = ""
    @Persisted var nativeName: Map<String, RealmChildName?>
}

final class RealmChildName: EmbeddedObject {
    @Persisted var common: String = ""
    @Persisted var official: String = ""
}

final class RealmCurrency: EmbeddedObject {
    @Persisted var name: String = ""
    @Persisted var symbol: String?
}

final class RealmInternationalDirectDialing: EmbeddedObject {
    @Persisted var root: String?
    @Persisted var suffixes: List<String>
}

final class RealmTranslation: EmbeddedObject {
    @Persisted var official: String = ""
    @Persisted var common: String = ""
}

final class RealmDemonym: EmbeddedObject {
    @Persisted var female: String = ""
    @Persisted var male: String = ""
}

final class RealmMaps: EmbeddedObject {
    @Persisted var googleMaps: String = ""
    @Persisted var openStreetMaps: String = ""
}

final class RealmCar: EmbeddedObject {
    @Persisted var signs: List<String>
    @Persisted var side: String = ""
}

final class RealmImages: EmbeddedObject {
    @Persisted var png: String?
    @Persisted var svg: String?
    @Persisted var alt: String?
}

final class RealmCapitalInfo: EmbeddedObject  {
    @Persisted var latitudeAndLongitude: List<Double>
}

final class RealmPostalCode: EmbeddedObject {
    @Persisted var format: String = ""
    @Persisted var regex: String?
}

// MARK: - Object

final class RealmCountry: Object {

    @Persisted var name: RealmName?
    @Persisted var topLevelDomains: List<String>
    @Persisted var cca2: String = ""
    @Persisted var ccn3: String?
    @Persisted var cca3: String = ""
    @Persisted var cioc: String?
    @Persisted var independent: Bool?
    @Persisted var status: String = ""
    @Persisted var unMember: Bool = false
    @Persisted var currencies: Map<String, RealmCurrency?>
    @Persisted var internationalDirectDialing: RealmInternationalDirectDialing?
    @Persisted var capital: List<String>
    @Persisted var altSpellings: List<String>
    @Persisted var region: String = ""
    @Persisted var subregion: String?
    @Persisted var languages: Map<String, String>
    @Persisted var translations:Map<String, RealmTranslation?>
    @Persisted var latitudeAndLongitude: List<Double>
    @Persisted var landlocked: Bool = false
    @Persisted var borders: List<String>
    @Persisted var area: Double = 0
    @Persisted var demonyms: Map<String, RealmDemonym?>
    @Persisted var flag: String = ""
    @Persisted var maps: RealmMaps?
    @Persisted var population: Int = 0
    @Persisted var giniCoefficient: Map<String, Double>
    @Persisted var fifa: String?
    @Persisted var car: RealmCar?
    @Persisted var timezones: List<String>
    @Persisted var continents: List<String>
    @Persisted var flags: RealmImages?
    @Persisted var coatOfArms: RealmImages?
    @Persisted var startOfWeek: String = ""
    @Persisted var capitalInfo: RealmCapitalInfo?
    @Persisted var postalCode: RealmPostalCode?

}

// MARK: - RealmCountry <-> Country

extension RealmName {

    convenience init(from model: Country.Name) {
        self.init()
        common = model.common
        official = model.official
        nativeName = Map()
        for (key, value) in (model.nativeName ?? [:]) {
            nativeName.setValue(RealmChildName(from: value), forKey: key)
        }
    }

    func toModel() -> Country.Name {
        let modelNativeName: [String: Country.Name]?
        if nativeName.count == 0 {
            modelNativeName = nil
        } else {
            modelNativeName = nativeName.map { ($0.key, $0.value!.toModel()) }.reduce(into: [:]) { $0[$1.0] = $1.1 }
        }
        return Country.Name(common: common,
                            official: official,
                            nativeName: modelNativeName)
    }

}

extension RealmChildName {

    convenience init(from model: Country.Name) {
        self.init()
        common = model.common
        official = model.official
    }

    func toModel() -> Country.Name {
        return Country.Name(common: common,
                            official: official,
                            nativeName: nil)
    }

}

extension RealmCurrency {

    convenience init(from model: Country.Currency) {
        self.init()
        name = model.name
        symbol = model.symbol
    }

    func toModel() -> Country.Currency {
        .init(name: name, symbol: symbol)
    }

}

extension RealmInternationalDirectDialing {

    convenience init(from model: Country.InternationalDirectDialing) {
        self.init()
        root = model.root
        suffixes = List()
        suffixes.append(objectsIn: model.suffixes ?? [])
    }

    func toModel() -> Country.InternationalDirectDialing {
        .init(root: root, suffixes: suffixes.count == 0 ? nil : Array(suffixes))
    }

}

extension RealmTranslation {

    convenience init(from model: Country.Translation) {
        self.init()
        official = model.official
        common = model.common
    }

    func toModel() -> Country.Translation {
        .init(official: official, common: common)
    }

}

extension RealmDemonym {

    convenience init(from model: Country.Demonym) {
        self.init()
        female = model.female
        male = model.male
    }

    func toModel() -> Country.Demonym {
        .init(female: female, male: male)
    }

}

extension RealmMaps {

    convenience init(from model: Country.Maps) {
        self.init()
        googleMaps = model.googleMaps.absoluteString
        openStreetMaps = model.openStreetMaps.absoluteString
    }

    func toModel() -> Country.Maps {
        .init(googleMaps: .init(string: googleMaps)!,
              openStreetMaps: .init(string: openStreetMaps)!)
    }

}

extension RealmCar {

    convenience init(from model: Country.Car) {
        self.init()
        signs = List()
        signs.append(objectsIn: model.signs ?? [])
        side = model.side
    }

    func toModel() -> Country.Car {
        .init(signs: signs.count == 0 ? nil : Array(signs),
              side: side)
    }

}

extension RealmImages {

    convenience init(from model: Country.Images) {
        self.init()
        png = model.png?.absoluteString
        svg = model.svg?.absoluteString
        alt = model.alt
    }

    func toModel() -> Country.Images {
        .init(png: URL(string: png ?? ""),
              svg: URL(string: svg ?? ""),
              alt: alt)
    }

}

extension RealmCapitalInfo {

    convenience init(from model: Country.CapitalInfo) {
        self.init()
        latitudeAndLongitude = List()
        latitudeAndLongitude.append(objectsIn: model.latitudeAndLongitude ?? [])
    }

    func toModel() -> Country.CapitalInfo {
        .init(latitudeAndLongitude: latitudeAndLongitude.count == 0 ? nil : Array(latitudeAndLongitude))
    }

}

extension RealmPostalCode {

    convenience init(from model: Country.PostalCode) {
        self.init()
        format = model.format
        regex = model.regex
    }

    func toModel() -> Country.PostalCode {
        .init(format: format, regex: regex)
    }

}

extension RealmCountry {

    convenience init(from model: Country) {
        self.init()
        name = .init(from: model.name)
        topLevelDomains = List()
        topLevelDomains.append(objectsIn: model.topLevelDomains ?? [])
        cca2 = model.cca2
        ccn3 = model.ccn3
        cca3 = model.cca3
        cioc = model.cioc
        independent = model.independent
        status = model.status
        unMember = model.unMember
        currencies = Map()
        for (key, value) in (model.currencies ?? [:]) {
            currencies.setValue(RealmCurrency(from: value), forKey: key)
        }
        internationalDirectDialing = .init(from: model.internationalDirectDialing)
        capital = List()
        capital.append(objectsIn: model.capital ?? [])
        altSpellings = List()
        altSpellings.append(objectsIn: model.altSpellings)
        region = model.region
        subregion = model.subregion
        languages = Map()
        for (key, value) in (model.languages ?? [:]) {
            languages.setValue(value, forKey: key)
        }
        translations = Map()
        for (key, value) in model.translations {
            translations.setValue(RealmTranslation(from: value), forKey: key)
        }
        latitudeAndLongitude = List()
        latitudeAndLongitude.append(objectsIn: model.latitudeAndLongitude)
        landlocked = model.landlocked
        borders = List()
        borders.append(objectsIn: model.borders ?? [])
        area = model.area
        demonyms = Map()
        for (key, value) in (model.demonyms ?? [:]) {
            demonyms.setValue(RealmDemonym(from: value), forKey: key)
        }
        flag = model.flag
        maps = .init(from: model.maps)
        population = model.population
        giniCoefficient = Map()
        for (key, value) in (model.giniCoefficient ?? [:]) {
            giniCoefficient.setValue(value, forKey: key)
        }
        fifa = model.fifa
        car = .init(from: model.car)
        timezones = List()
        timezones.append(objectsIn: model.timezones)
        continents = List()
        continents.append(objectsIn: model.continents)
        flags = .init(from: model.flags)
        coatOfArms = .init(from: model.coatOfArms)
        startOfWeek = model.startOfWeek
        capitalInfo = .init(from: model.capitalInfo)
        postalCode = model.postalCode.map { RealmPostalCode(from: $0) }
    }

    func toModel() -> Country {
        Country(name: name!.toModel(),
                topLevelDomains: topLevelDomains.count == 0 ? nil : Array(topLevelDomains),
                cca2: cca2,
                ccn3: ccn3,
                cca3: cca3,
                cioc: cioc,
                independent: independent,
                status: status,
                unMember: unMember,
                currencies: currencies.count == 0 ? nil : currencies.map { ($0.key, $0.value!.toModel()) }.reduce(into: [:]) { $0[$1.0] = $1.1 },
                internationalDirectDialing: internationalDirectDialing!.toModel(),
                capital: capital.count == 0 ? nil : Array(capital),
                altSpellings: Array(altSpellings),
                region: region,
                subregion: subregion,
                languages: languages.count == 0 ? nil : languages.map { ($0.key, $0.value) }.reduce(into: [:]) { $0[$1.0] = $1.1 },
                translations: translations.map { ($0.key, $0.value!.toModel()) }.reduce(into: [:]) { $0[$1.0] = $1.1 },
                latitudeAndLongitude: Array(latitudeAndLongitude),
                landlocked: landlocked,
                borders: borders.count == 0 ? nil : Array(borders),
                area: area,
                demonyms: demonyms.count == 0 ? nil : demonyms.map { ($0.key, $0.value!.toModel()) }.reduce(into: [:]) { $0[$1.0] = $1.1 },
                flag: flag,
                maps: maps!.toModel(),
                population: population,
                giniCoefficient: giniCoefficient.count == 0 ? nil : giniCoefficient.map { ($0.key, $0.value) }.reduce(into: [:]) { $0[$1.0] = $1.1 },
                fifa: fifa,
                car: car!.toModel(),
                timezones: Array(timezones),
                continents: Array(continents),
                flags: flags!.toModel(),
                coatOfArms: coatOfArms!.toModel(),
                startOfWeek: startOfWeek,
                capitalInfo: capitalInfo!.toModel(),
                postalCode: postalCode?.toModel())
    }

}
