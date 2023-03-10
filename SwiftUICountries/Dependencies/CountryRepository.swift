//
//  CountryRepository.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 08/03/2023.
//

import Foundation
import ComposableArchitecture

// MARK: - Skeleton

struct CountryRepository {
  var fetchAll: () async throws -> [Country]
}

// MARK: - Live Implementation

extension CountryRepository: DependencyKey {
    static var liveValue = CountryRepository(fetchAll: {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Country].self, from: data)
    })
}

// MARK: - Dependency

extension DependencyValues {
  var countryRepository: CountryRepository {
    get { self[CountryRepository.self] }
    set { self[CountryRepository.self] = newValue }
  }
}
