//
//  SwiftUICountriesApp.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 08/03/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftUICountriesApp: App {

    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(
                    store: Store(
                        initialState: AppFeature.State(),
                        reducer: AppFeature()
                    )
                )
            }
        }
    }

}
