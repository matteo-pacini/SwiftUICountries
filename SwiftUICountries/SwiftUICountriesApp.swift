import SwiftUI
import ComposableArchitecture

@main
struct SwiftUICountriesApp: App {

    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(
                    store: Store(
                        initialState: AppReducer.State(),
                        reducer: AppReducer()
                    )
                )
            } else {
                VStack {
                    Text("Unit testing in progress...")
                }
            }
        }
    }

}
