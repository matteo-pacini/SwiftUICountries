import SwiftUI
import ComposableArchitecture

struct CountryView: View {

    let store: StoreOf<CountryReducer>

    @ViewBuilder
    func flagSection(viewStore: ViewStoreOf<CountryReducer>) -> some View {
        Section {
            CountryViewFlag(country: viewStore.country)
        }
    }

    @ViewBuilder
    func detailsSection(viewStore: ViewStoreOf<CountryReducer>) -> some View {
        Section("country.section.details") {
            CountryViewRow(left: "country.section.details.officialName", right: viewStore.country.name.official)
            if let independent = viewStore.country.independent {
                CountryViewRow(left: "country.section.details.independent", right: independent ? "generic.yes" : "generic.no")
            }
            CountryViewRow(left: "country.section.details.unMember", right: viewStore.country.unMember ? "generic.yes" : "generic.no")
            CountryViewRow(left: "country.section.details.region", right: viewStore.country.region)
            if let subregion = viewStore.country.subregion {
                CountryViewRow(left: "country.section.details.subregion", right: subregion)
            }
            if let capital = viewStore.country.capital?.first,
               let capitalCoordinate = viewStore.country.capitalInfo.latitudeAndLongitude {
                #if os(iOS)
                CountryViewRowLink(left: "country.section.details.capital", right: capital) {
                    MapView(latitude: capitalCoordinate[0],
                            longitude: capitalCoordinate[1],
                            inNavigationView: true)
                }
                #else
                CountryViewRow(left: "country.section.details.capital", right: capital)
                MapView(latitude: capitalCoordinate[0],
                        longitude: capitalCoordinate[1],
                        inNavigationView: false)
                    .frame(height: 250)
                    .allowsHitTesting(false)
                #endif
            }
            CountryViewRow(left: "country.section.details.population", right: "\(viewStore.country.population.formattedForDisplay)")
        }
    }

    @ViewBuilder
    func bordersSection(viewStore: ViewStoreOf<CountryReducer>) -> some View {
        if !viewStore.neighborCountries.isEmpty {
            Section("country.section.borders") {
                ForEachStore(
                    self.store.scope(state: \.neighborCountries, action: CountryReducer.Action.neighborCountry(id:action:))
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
    func currencySection(viewStore: ViewStoreOf<CountryReducer>) -> some View {
        if let currencies = viewStore.country.currencies {
            Section("country.section.currencies") {
                ForEach(Array(currencies.keys.sorted()), id: \.self) { key in
                    CountryViewRow(left: key, right: currencies[key]!.name)
                }
            }
        }
    }

    @ViewBuilder
    func dailyLifeSection(viewStore: ViewStoreOf<CountryReducer>) -> some View{
        Section("country.section.dailyLife") {
            CountryViewRow(left: "country.section.dailyLife.startOfWeek", right: viewStore.country.startOfWeek.capitalized)
            CountryViewRow(left: "country.section.dailyLife.drivingSide", right: viewStore.country.car.side.capitalized)
        }
    }

    @ViewBuilder
    func timezonesSection(viewStore: ViewStoreOf<CountryReducer>) -> some View {
        Section("country.section.timezones") {
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewStore.send(.favoriteTapped)
                    }, label: {
                        viewStore.country.favorite ?
                        Image(systemName: "heart.fill").foregroundColor(.red) :
                        Image(systemName: "heart").foregroundColor(.red)
                    })
                }
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
                    initialState: CountryReducer.State(country: .italy),
                    reducer: CountryReducer()
                )
            )
            .previewDisplayName("Italy")
        }

    }

}
