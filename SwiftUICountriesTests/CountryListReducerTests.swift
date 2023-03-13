import XCTest
import ComposableArchitecture
import Combine
@testable import SwiftUICountries

@MainActor
final class CountryListReducerTests: XCTestCase {

    func testRegistersWithDatabasePublisherOnAppear() async {

        let store = TestStore(initialState: CountryListReducer.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [] }
            $0.countryDatabase.publisher = Just(TaskResult.success([.italy])).eraseToAnyPublisher()
        } operation: {
            CountryListReducer()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriedFetchedLocally(.success([.italy]))) {
            $0.isFetching = false
            $0.allCountries = [.italy]
            $0.countries = .init(uniqueElements:
                [.init(country: .italy)]
            )
        }

    }

    func testOnQueryUpdateListIsUpdated() async {

        let allCountries = [Country.italy]

        let store = TestStore(initialState: CountryListReducer.State(countries: .init(uniqueElements: [.init(country: .italy)]),
                                                                     allCountries: allCountries),
                              reducer: CountryListReducer())

        store.exhaustivity = .on

        await store.send(.set(\.$query, "Spain")) {
            // No matches
            $0.query = "Spain"
            $0.countries = .init(uniqueElements:
                []
            )
        }

        await store.send(.set(\.$query, "Ita")) {
            // 1 match
            $0.query = "Ita"
            $0.countries = .init(uniqueElements:
                [.init(country: .italy)]
            )
        }

        await store.send(.set(\.$query, "")) {
            // Empty search = list is not filtered
            $0.query = ""
            $0.countries = .init(uniqueElements: allCountries.map { .init(country: $0) })
        }

    }

    func testPublisherErrorRaisesAnAlert() async {

        struct SomeError: Error, Equatable {}

        let error = SomeError()

        let store = TestStore(initialState: CountryListReducer.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [] }
            $0.countryDatabase.publisher = Just(TaskResult.failure(error)).eraseToAnyPublisher()
        } operation: {
            CountryListReducer()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriedFetchedLocally(.failure(error))) {
            $0.isFetching = false
            $0.alert = AlertState(title: {
                TextState("generic.error")
            }, actions: {
                ButtonState {
                    TextState("generic.dismiss")
                }
            }, message: {
                TextState(verbatim: error.localizedDescription)
            })
        }

    }

    func testDismissingAlertNilsOutAlertState() async {

        let alertState = AlertState<CountryListReducer.Action>(title: {
            TextState("generic.error")
        }, actions: {
            ButtonState {
                TextState("generic.dismiss")
            }
        }, message: {
            TextState("An error occurred")
        })

        let store = TestStore(initialState: CountryListReducer.State(alert: alertState),
                              reducer: CountryListReducer())

        store.exhaustivity = .on

        await store.send(.alertDismissed) {
            $0.alert = nil
        }

    }

    func testRegistersWithDatabasePublisherOnAppearAndFetchesCountriesOnlineIfDatabaseIsEmpty() async {

        let store = TestStore(initialState: CountryListReducer.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [.italy] }
            $0.countryDatabase.publisher = Just(TaskResult.success([])).eraseToAnyPublisher()
        } operation: {
            CountryListReducer()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriedFetchedLocally(.success([])))

        await store.receive(.countriesDownloaded(.success([.italy])))

    }

    func testRegistersWithDatabasePublisherOnAppearAndFetchesCountriesOnlineIfDatabaseIsEmptyAndSetsAlertOnError() async {

        struct SomeError: Error, Equatable {}

        let error = SomeError()

        let store = TestStore(initialState: CountryListReducer.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { throw error }
            $0.countryDatabase.publisher = Just(TaskResult.success([])).eraseToAnyPublisher()
        } operation: {
            CountryListReducer()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriedFetchedLocally(.success([])))

        let alertState = AlertState<CountryListReducer.Action>(title: {
            TextState("generic.error")
        }, actions: {
            ButtonState {
                TextState("generic.dismiss")
            }
        }, message: {
            TextState(verbatim: error.localizedDescription)
        })

        await store.receive(.countriesDownloaded(.failure(error))) {
            $0.isFetching = false
            $0.alert = alertState
        }

    }

    func testChildErrorPropagatesToParent() async {

        struct SomeError: Error, Equatable {}

        let error = SomeError()

        let parent = TestStore(initialState: CountryListReducer.State(countries: .init(uniqueElements: [.init(country: .italy)])),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [] }
            $0.countryDatabase.publisher = Just(TaskResult.success([])).eraseToAnyPublisher()
        } operation: {
            CountryListReducer()
        })

        parent.exhaustivity = .on

        await parent.send(.country(id: Country.italy.id, action: .neighborCountriesFetched(.failure(error)))) {
            $0.alert = AlertState(title: {
                TextState("generic.error")
            }, actions: {
                ButtonState {
                    TextState("generic.dismiss")
                }
            }, message: {
                TextState(verbatim: error.localizedDescription)
            })
        }

    }


}
