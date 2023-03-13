import Foundation
import ComposableArchitecture
import RealmSwift
import Combine

// MARK: - Skeleton

struct CountryDatabase {
    var publisher: AnyPublisher<TaskResult<[Country]>, Never>
    var fetchNeighbors: (Country) async throws -> [Country]
    var store: ([Country]) async throws -> Void
    var toggleFavorite: (Country) async throws -> Void
}

// MARK: - Country / Live Implementation

extension CountryDatabase: DependencyKey {

    private static let persistenceQueue = DispatchQueue(label: "it.codecraft.SwiftUIContries.persistenceQueue")

    static var liveValue: CountryDatabase = .init(publisher: {

        do {
            return try Realm()
                .objects(RealmCountry.self)
                .sorted(byKeyPath: "name.common", ascending: true)
                .collectionPublisher
                .subscribe(on: persistenceQueue)
                .map { Array($0.map { $0.toModel() }) }
                .catchToResult()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Just(.failure(error)).eraseToAnyPublisher()
        }

    }(), fetchNeighbors: { country in

        try Realm().objects(RealmCountry.self)
            .filter("ANY borders CONTAINS %@", country.cca3)
            .map { $0.toModel() }

    }, store: { countries in

        try Realm().write {
            let realmModels = countries.map { RealmCountry(from: $0) }
            try Realm().add(realmModels)
        }
    
    }, toggleFavorite: { country in

        try Realm()
            .objects(RealmCountry.self)
            .filter("name.common = %@", country.name.common)
            .forEach { result in
                try Realm().write {
                    result.favorite = !result.favorite
                }
            }
    })

}

// MARK: - Dependencies

extension DependencyValues {

    var countryDatabase: CountryDatabase {
        get { self[CountryDatabase.self] }
        set { self[CountryDatabase.self] = newValue }
    }

}
