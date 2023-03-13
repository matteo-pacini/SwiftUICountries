import Foundation
import ComposableArchitecture

struct CountryListReducer: ReducerProtocol {

    struct State: Equatable {
        var isFetching: Bool = false
        @BindingState var query: String = ""
        var countries: IdentifiedArrayOf<CountryReducer.State> = []
        var allCountries: [Country] = []
        var alert: AlertState<Action>?
    }

    enum Action: Equatable, BindableAction {
        case onAppear
        case alertDismissed
        case binding(BindingAction<State>)
        case countriedFetchedLocally(TaskResult<[Country]>)
        case countriesDownloaded(TaskResult<[Country]>)
        case country(id: Country.ID, action: CountryReducer.Action)
    }

    @Dependency(\.countryRepository) var countryRepository
    @Dependency(\.countryDatabase) var countryDatabase

    var body: some ReducerProtocol<State, Action> {

        BindingReducer()

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
                         .map(CountryListReducer.Action.countriedFetchedLocally)
                }

            case .binding(\.$query):

                let filteredCountries = state.query.isEmpty ? state.allCountries : state.allCountries.filter { $0.id.contains(state.query) }

                state.countries = .init(uniqueElements: filteredCountries.map { country in
                    CountryReducer.State(country: country)
                })

                return .none

            case .binding:
                return .none

            case let .countriedFetchedLocally(.success(countries)):

                if !countries.isEmpty {
                    state.isFetching = false
                    state.allCountries = countries
                    state.countries = .init(uniqueElements: state.allCountries.map { country in
                        CountryReducer.State(country: country)
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
                    TextState("generic.error")
                }, actions: {
                    ButtonState {
                        TextState("generic.dismiss")
                    }
                }, message: {
                    TextState(verbatim: error.localizedDescription)
                })
                return .none

            case let .country(_, .neighborCountriesFetched(.failure(error))):

                state.alert = AlertState(title: {
                    TextState("generic.error")
                }, actions: {
                    ButtonState {
                        TextState("generic.dismiss")
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
            CountryReducer()
        }
    }

}
