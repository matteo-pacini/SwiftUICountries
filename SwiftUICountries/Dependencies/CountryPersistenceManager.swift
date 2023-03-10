//
//  CountryPersistenceManager.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//

import Foundation
import ComposableArchitecture

// MARK: - Skeleton

struct CountryPersistenceManager {
    var fetch: () async throws -> [Country]
    var store: ([Country]) async throws -> Void
}

// MARK: - Country / Live Implementation

extension CountryPersistenceManager: DependencyKey {

    private static var jsonFileURL: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("countries.json")

    static var liveValue: CountryPersistenceManager = .init(fetch: {
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: jsonFileURL)
        return try decoder.decode([Country].self, from: data)
    }, store: { countries in
        let encoder = JSONEncoder()
        let data = try encoder.encode(countries)
        try data.write(to: jsonFileURL)
    })

}

// MARK: - Dependency

extension DependencyValues {
  var countryPersistenceManager: CountryPersistenceManager {
    get { self[CountryPersistenceManager.self] }
    set { self[CountryPersistenceManager.self] = newValue }
  }
}
