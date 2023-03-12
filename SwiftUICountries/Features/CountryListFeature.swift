//
//  CountryListFeature.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI
import ComposableArchitecture
import RealmSwift
import Combine

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
        case countriedFetchedLocally(TaskResult<[Country]>)
        case countriesDownloaded(TaskResult<[Country]>)
        case country(id: Country.ID, action: CountryFeature.Action)
    }

    @Dependency(\.countryRepository) var countryRepository
    @Dependency(\.countryDatabase) var countryDatabase

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in

            switch action {

            case .alertDismissed:

                state.alert = nil
                return .none

            case .onAppear:

                state.isFetching = true

                return .publisher {
                    countryDatabase
                        .publisher
                         .map(CountryListFeature.Action.countriedFetchedLocally)
                }

            case let .countriedFetchedLocally(.success(countries)):

                if !countries.isEmpty {
                    state.isFetching = false
                    state.countries = .init(uniqueElements: countries.map { country in
                        CountryFeature.State(country: country)
                    })
                    return .none
                }

                // Fetch countries online if database is empty

                return .task {
                    await .countriesDownloaded(
                        TaskResult {
                            let countries = try await countryRepository.fetchAll()
                            try await countryDatabase.store(countries)
                            return countries
                        }
                    )
                }


            case .countriesDownloaded(.success):
                return .none

            case let .countriesDownloaded(.failure(error)),
                 let .countriedFetchedLocally(.failure(error)):

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
                  } operation: {
                    CountryListFeature()
                  }
            )
        )
        .previewDisplayName("List")
    }

}
