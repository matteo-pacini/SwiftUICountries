import SwiftUI
import ComposableArchitecture

struct AppView: View {

    let store: StoreOf<AppReducer>

    var body: some View {

        CountryListView(store:
            store.scope(state: \.countryListState, action: AppReducer.Action.countryList)
        )
        .tabItem {
            Label("Countries", systemImage: "globe.europe.africa.fill")
        }
    }

}
