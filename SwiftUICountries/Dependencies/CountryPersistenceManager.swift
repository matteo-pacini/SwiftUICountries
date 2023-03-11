//
//  CountryPersistenceManager.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//

import Foundation
import ComposableArchitecture
import RealmSwift

// MARK: - Skeleton

struct CountryPersistenceManager {
    var fetch: () async throws -> [Country]
    var fetchNeighbors: (Country) async throws -> [Country]
    var store: ([Country]) async throws -> Void
}

// MARK: - Country / Live Implementation

extension CountryPersistenceManager: DependencyKey {

    static var liveValue: CountryPersistenceManager = .init(fetch: {
        try Realm().objects(RealmCountry.self).map { $0.toModel() }
    }, fetchNeighbors: { country in
        try Realm().objects(RealmCountry.self).filter("ANY borders CONTAINS %@", country.cca3).map { $0.toModel() }
    }, store: { countries in
        try Realm().write {
            let realmModels = countries.map { RealmCountry(from: $0) }
            try Realm().add(realmModels, update: .error)
        }
    })

}

// MARK: - Dependency

extension DependencyValues {
  var countryPersistenceManager: CountryPersistenceManager {
    get { self[CountryPersistenceManager.self] }
    set { self[CountryPersistenceManager.self] = newValue }
  }
}
