import SwiftUI
import ComposableArchitecture

struct AppReducer: ReducerProtocol {

    struct State: Equatable {
        var countryListState = CountryListReducer.State()
    }

    enum Action: Equatable {
        case countryList(CountryListReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {

        Scope(state: \.countryListState,
              action: /Action.countryList) {
            CountryListReducer()
        }

    }

}
