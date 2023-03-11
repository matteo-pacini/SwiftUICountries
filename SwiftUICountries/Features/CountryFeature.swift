//
//  CountryFeature.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI
import ComposableArchitecture

// MARK: - Feature

struct CountryFeature: ReducerProtocol {

    struct State: Equatable, Identifiable {
        let country: Country
        var neighborCountries: IdentifiedArrayOf<CountryFeature.State> = []
        var id: String { country.id }
    }

    indirect enum Action: Equatable {
        case onAppear
        case neighborCountriesFetched(TaskResult<[Country]>)
        case neighborCountry(id: Country.ID, action: Action)
    }

    struct Environment {

    }

    @Dependency(\.countryPersistenceManager) var countryPersistenceManager

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let borders = state.country.borders ?? []
                return .task {
                    await .neighborCountriesFetched(
                        TaskResult {
                            let countries = try await countryPersistenceManager.fetch()
                            let neighborCountries = countries.filter { borders.contains($0.cca3) }.sorted { $0.id < $1.id }
                            return neighborCountries
                        }
                    )
                }
            case let .neighborCountriesFetched(.success(countries)):
                state.neighborCountries = .init(uniqueElements: countries.map { CountryFeature.State(country: $0) })
                return .none
            case let .neighborCountriesFetched(.failure(error)):
                debugPrint(error)
                return .none
            case .neighborCountry:
                return .none
            }
        }
        .forEach(\.neighborCountries, action: /Action.neighborCountry) {
            CountryFeature()
        }
    }

}

// MARK: - View

struct CountryView: View {

    let store: StoreOf<CountryFeature>

    @ViewBuilder
    func flagSection(viewStore: ViewStoreOf<CountryFeature>) -> some View {
        Section {
            CountryViewFlag(country: viewStore.country)
        }
    }

    @ViewBuilder
    func detailsSection(viewStore: ViewStoreOf<CountryFeature>) -> some View {
        Section("Details") {
            CountryViewRow(left: "Official Name", right: viewStore.country.name.official)
            if let independent = viewStore.country.independent {
                CountryViewRow(left: "Independent", right: independent ? "Yes" : "No")
            }
            CountryViewRow(left: "UN Member", right: viewStore.country.unMember ? "Yes" : "No")
            CountryViewRow(left: "Region", right: viewStore.country.region)
            if let subregion = viewStore.country.subregion {
                CountryViewRow(left: "Subregion", right: subregion)
            }
            if let capital = viewStore.country.capital?.first,
               let capitalCoordinate = viewStore.country.capitalInfo.latitudeAndLongitude {
                #if os(iOS)
                CountryViewRowLink(left: "Capital", right: capital) {
                    MapView(latitude: capitalCoordinate[0],
                            longitude: capitalCoordinate[1],
                            inNavigationView: true)
                }
                #else
                CountryViewRow(left: "Capital", right: capital)
                MapView(latitude: capitalCoordinate[0],
                        longitude: capitalCoordinate[1],
                        inNavigationView: false)
                    .frame(height: 250)
                    .allowsHitTesting(false)
                #endif
            }
            CountryViewRow(left: "Population", right: "\(viewStore.country.population.formattedForDisplay)")
        }
    }

    @ViewBuilder
    func bordersSection(viewStore: ViewStoreOf<CountryFeature>) -> some View {
        if !viewStore.neighborCountries.isEmpty {
            Section("Borders") {
                ForEachStore(
                    self.store.scope(state: \.neighborCountries, action: CountryFeature.Action.neighborCountry(id:action:))
                ) { childStore in
                    WithViewStore(childStore, observe: \.country) { childViewStore in
                        CountryViewRowLink(left: childViewStore.flag, right: childViewStore.name.common) {
                            CountryView(store: childStore)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func currencySection(viewStore: ViewStoreOf<CountryFeature>) -> some View {
        if let currencies = viewStore.country.currencies {
            Section("Currencies") {
                ForEach(Array(currencies.keys.sorted()), id: \.self) { key in
                    CountryViewRow(left: key, right: currencies[key]!.name)
                }
            }
        }
    }

    @ViewBuilder
    func dailyLifeSection(viewStore: ViewStoreOf<CountryFeature>) -> some View{
        Section("Daily Life") {
            CountryViewRow(left: "Start of the week", right: viewStore.country.startOfWeek.capitalized)
            CountryViewRow(left: "Driving side", right: viewStore.country.car.side.capitalized)
        }
    }

    @ViewBuilder
    func timezonesSection(viewStore: ViewStoreOf<CountryFeature>) -> some View {
        Section("Timezones") {
            ForEach(viewStore.country.timezones, id: \.self) { timezone in
                CountryViewRow(left: nil, right: timezone)
            }
        }
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                flagSection(viewStore: viewStore)
                detailsSection(viewStore: viewStore)
                bordersSection(viewStore: viewStore)
                currencySection(viewStore: viewStore)
                dailyLifeSection(viewStore: viewStore)
                timezonesSection(viewStore: viewStore)
            }
            .navigationTitle(viewStore.country.name.common)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

}

// MARK: - Previews

struct CountryView_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {
            CountryView(
                store: Store(
                    initialState: CountryFeature.State(country: .italy),
                    reducer: withDependencies {
                        $0.countryPersistenceManager.fetch = { [] }
                        $0.countryPersistenceManager.store = { _ in }
                    } operation: {
                        CountryFeature()
                    }
                )
            )
            .previewDisplayName("Italy")
        }

    }

}
