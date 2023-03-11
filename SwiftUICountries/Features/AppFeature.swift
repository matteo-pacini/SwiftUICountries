//
//  AppFeature.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 10/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI
import ComposableArchitecture

// MARK: - Feature

struct AppFeature: ReducerProtocol {

    struct State: Equatable {
        var countryListState = CountryListFeature.State()
    }

    enum Action: Equatable {
        case countryList(CountryListFeature.Action)
    }

    struct Environment {

    }

    var body: some ReducerProtocol<State, Action> {

        Scope(state: \.countryListState,
              action: /Action.countryList) {
            CountryListFeature()
        }

    }

}

// MARK: - View

struct AppView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        
        CountryListView(store:
            store.scope(state: \.countryListState, action: AppFeature.Action.countryList)
        )
        .tabItem {
            Label("Countries", systemImage: "globe.europe.africa.fill")
        }
    }

}
