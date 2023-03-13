import SwiftUI
import ComposableArchitecture

struct CountryReducer: ReducerProtocol {

    struct State: Equatable, Identifiable {
        let country: Country
        var neighborCountries: IdentifiedArrayOf<CountryReducer.State> = []
        var id: String { country.id }
    }

    indirect enum Action: Equatable {
        case onAppear
        case neighborCountriesFetched(TaskResult<[Country]>)
        case neighborCountry(id: Country.ID, action: Action)
        case favoriteTapped
        case favoriteToggled
    }

    @Dependency(\.countryDatabase) var countryDatabase

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let country = state.country
                return .task {
                    await .neighborCountriesFetched(
                        TaskResult {
                            try await countryDatabase.fetchNeighbors(country)
                        }
                    )
                }
            case let .neighborCountriesFetched(.success(countries)):
                state.neighborCountries = .init(uniqueElements: countries.map { CountryReducer.State(country: $0) })
                return .none
            case .neighborCountriesFetched(.failure):
                // Propagated to parent
                return .none
            case .neighborCountry:
                return .none
            case .favoriteTapped:
                let country = state.country
                return .task {
                    try await countryDatabase.toggleFavorite(country)
                    return .favoriteToggled
                }
            case .favoriteToggled:
                return .none
            }
        }
        .forEach(\.neighborCountries, action: /Action.neighborCountry) {
            CountryReducer()
        }
    }

}
