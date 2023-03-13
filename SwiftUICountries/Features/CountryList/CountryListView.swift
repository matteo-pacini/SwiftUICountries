import SwiftUI
import ComposableArchitecture
import RealmSwift
import Combine

// MARK: - View

struct CountryListView: View {

    let store: StoreOf<CountryListReducer>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    if viewStore.isFetching {
                        Text("countryList.fetching")
                    } else {
                        if viewStore.countries.isEmpty {
                            Text("countryList.empty")
                        } else {
                            ForEachStore(
                                store.scope(state: \.countries, action:CountryListReducer.Action.country(id:action:))
                            ) { (childStore: StoreOf<CountryReducer>) in
                                NavigationLink(destination: {
                                    CountryView(store: childStore)
                                }, label: {
                                    WithViewStore(childStore, observe: \.country) { childViewStore in
                                        Text(verbatim: "\(childViewStore.flag) \(childViewStore.name.common)")
                                    }
                                })
                            }
                        }
                    }
                }
                .searchable(text: viewStore.binding(\.$query))
                .navigationTitle(Text("countryList.navigationTitle"))
            }
            #if os(iOS)
            // https://forums.swift.org/t/how-to-manage-foreachstore-with-navigationlinks-binding/36459/2
            .navigationViewStyle(
                StackNavigationViewStyle()
            )
            #endif
            .onAppear { viewStore.send(.onAppear) }
            .alert(store.scope(state: \.alert),
                   dismiss: CountryListReducer.Action.alertDismissed)
        }
    }

}

// MARK: - Previews

struct CountryListView_Previews: PreviewProvider {

    static var previews: some View {

        CountryListView(
            store: Store(
                initialState: CountryListReducer.State(),
                reducer: withDependencies {
                    $0.countryRepository.fetchAll = { [] }
                  } operation: {
                    CountryListReducer()
                  }
            )
        )
        .previewDisplayName("Empty list")

        CountryListView(
            store: Store(
                initialState: CountryListReducer.State(),
                reducer: withDependencies {
                    $0.countryRepository.fetchAll = { [.italy] }
                  } operation: {
                    CountryListReducer()
                  }
            )
        )
        .previewDisplayName("List")
    }

}
