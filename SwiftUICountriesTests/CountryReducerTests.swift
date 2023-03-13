import XCTest
import ComposableArchitecture
import Combine
@testable import SwiftUICountries

@MainActor
final class CountryReducerTests: XCTestCase {

    func testFetchesNeighborCountriesOnAppear() async {

        let store = TestStore(initialState: CountryReducer.State(country: .italy),
                              reducer: withDependencies {
            $0.countryDatabase.fetchNeighbors = { _ in [.italy] }
        } operation: {
            CountryReducer()
        })

        store.exhaustivity = .on

        await store.send(.onAppear)

        await store.receive(.neighborCountriesFetched(.success([.italy]))) {
            $0.neighborCountries = .init(uniqueElements: [
                .init(country: .italy)
            ])
        }

    }

    func testTriggersFavoriteActionsCorrectly() async {

        let store = TestStore(initialState: CountryReducer.State(country: .italy),
                              reducer: withDependencies {
            $0.countryDatabase.fetchNeighbors = { _ in [] }
            $0.countryDatabase.toggleFavorite = { _ in }
        } operation: {
            CountryReducer()
        })

        store.exhaustivity = .on

        await store.send(.favoriteTapped)

        await store.receive(.favoriteToggled)

    }

}
