//
//  CountryListFeature.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI
import ComposableArchitecture

// MARK: - Feature

struct CountryListFeature: ReducerProtocol {

    struct State: Equatable {
        var isFetching: Bool = false
        var countries: IdentifiedArrayOf<CountryFeature.State> = []
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case onAppear
        case alertDismissed
        case countriesFetched(TaskResult<[Country]>)
        case country(id: Country.ID, action: CountryFeature.Action)
    }

    struct Environment {

    }

    @Dependency(\.countryRepository) var countryRepository
    @Dependency(\.countryPersistenceManager) var countryPersistenceManager

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .alertDismissed:
                state.alert = nil
                return .none
            case .onAppear:
                state.isFetching = true
                return .task {
                    await .countriesFetched(TaskResult {
                        do {
                            let storedCountries = try await countryPersistenceManager.fetch()
                            if !storedCountries.isEmpty {
                                return storedCountries
                            }
                        } catch {
                            debugPrint("No stored countries - proceeding with live fetch...")
                        }
                        let countries = try await countryRepository.fetchAll().sorted { $0.id < $1.id }
                        try await countryPersistenceManager.store(countries)
                        return countries
                    })
                }
            case let .countriesFetched(.success(countries)):
                state.isFetching = false
                state.countries = .init(uniqueElements: countries.map { country in
                    CountryFeature.State(country: country)
                })
                return .none
            case let .countriesFetched(.failure(error)):
                state.isFetching = false
                state.alert = AlertState(title: {
                    TextState("Error")
                }, actions: {
                    ButtonState {
                        TextState("Dismiss")
                    }
                }, message: {
                    TextState(verbatim: error.localizedDescription)
                })
                return .none
            case .country:
                return .none
            }
        }
        .forEach(\.countries, action: /Action.country(id:action:)) {
            CountryFeature()
        }
    }

}

// MARK: - View

struct CountryListView: View {

    let store: StoreOf<CountryListFeature>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                if viewStore.countries.isEmpty {
                    VStack {
                        if viewStore.isFetching {
                            HStack {
                                Text("Fetching countries...")
                                ProgressView()
                            }
                        } else {
                            Text("No countries to display.")
                        }
                    }
                } else {
                    List {
                        ForEachStore(
                            store.scope(state: \.countries, action:CountryListFeature.Action.country(id:action:))
                        ) { (childStore: StoreOf<CountryFeature>) in
                            NavigationLink(destination: {
                                CountryView(store: childStore)
                            }, label: {
                                WithViewStore(childStore, observe: \.country) { childViewStore in
                                    Text(verbatim: "\(childViewStore.flag) \(childViewStore.name.common)")
                                }
                            })
                        }
                    }
                    .navigationTitle(Text("Countries"))
                }
            }
            #if os(iOS)
            // https://forums.swift.org/t/how-to-manage-foreachstore-with-navigationlinks-binding/36459/2
            .navigationViewStyle(
                StackNavigationViewStyle()
            )
            #endif
            .onAppear { viewStore.send(.onAppear) }
            .alert(store.scope(state: \.alert),
                   dismiss: CountryListFeature.Action.alertDismissed)
        }
    }

}

// MARK: - Previews

struct CountryListView_Previews: PreviewProvider {

    static var previews: some View {

        CountryListView(
            store: Store(
                initialState: CountryListFeature.State(),
                reducer: withDependencies {
                    $0.countryRepository.fetchAll = { [] }
                    $0.countryPersistenceManager.fetch = { [] }
                    $0.countryPersistenceManager.store = { _ in }
                  } operation: {
                    CountryListFeature()
                  }
            )
        )
        .previewDisplayName("Empty list")

        CountryListView(
            store: Store(
                initialState: CountryListFeature.State(),
                reducer: withDependencies {
                    $0.countryRepository.fetchAll = { [.italy] }
                    $0.countryPersistenceManager.fetch = { [] }
                    $0.countryPersistenceManager.store = { _ in }
                  } operation: {
                    CountryListFeature()
                  }
            )
        )
        .previewDisplayName("List")
    }

}
