//
//  SwiftUICountriesTests.swift
//  SwiftUICountriesTests
//
//  Created by Matteo Pacini on 10/03/2023.
//

import XCTest
import ComposableArchitecture
@testable import SwiftUICountries

@MainActor
final class CountryListFeatureTests: XCTestCase {

    func testFetchesCountriesOnAppear() async {

        let store = TestStore(initialState: CountryListFeature.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [.italy] }
            $0.countryPersistenceManager.fetch = { [] }
            $0.countryPersistenceManager.fetchNeighbors = { _ in [] }
            $0.countryPersistenceManager.store = { _ in }
        } operation: {
            CountryListFeature()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriesFetched(.success([.italy]))) {
            $0.isFetching = false
            $0.countries = .init(uniqueElements: [CountryFeature.State(country: .italy)])
        }

    }

    func testPrefersPersistedCountriesOnAppear() async {

        let store = TestStore(initialState: CountryListFeature.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = { [] }
            $0.countryPersistenceManager.fetch = { [.italy] }
            $0.countryPersistenceManager.fetchNeighbors = { _ in [] }
            $0.countryPersistenceManager.store = { _ in }
        } operation: {
            CountryListFeature()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        await store.receive(.countriesFetched(.success([.italy]))) {
            $0.isFetching = false
            $0.countries = .init(uniqueElements: [CountryFeature.State(country: .italy)])
        }

    }

    func testSetsAlertIfErrorOccursOnAppear() async {

        struct SomeError: Error, Equatable { }

        let store = TestStore(initialState: CountryListFeature.State(),
                              reducer: withDependencies {
            $0.countryRepository.fetchAll = {
                throw SomeError()
            }
            $0.countryPersistenceManager.fetch = { [] }
            $0.countryPersistenceManager.fetchNeighbors = { _ in [] }
            $0.countryPersistenceManager.store = { _ in }
        } operation: {
            CountryListFeature()
        })

        store.exhaustivity = .on

        await store.send(.onAppear) {
            $0.isFetching = true
        }

        let error = SomeError()

        await store.receive(.countriesFetched(.failure(error))) {
            $0.isFetching = false
            $0.alert = AlertState(title: {
                TextState("Error")
            }, actions: {
                ButtonState {
                    TextState("Dismiss")
                }
            }, message: {
                TextState(verbatim: error.localizedDescription)
            })
        }
        
        await store.send(.alertDismissed) {
            $0.alert = nil
        }

    }

}
