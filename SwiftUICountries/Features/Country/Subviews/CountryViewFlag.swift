import SwiftUI

struct CountryViewFlag: View {

    let country: Country

    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                
                // Flag
                AsyncImage(
                    url: country.flags.png,
                    content: {
                        $0.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .padding()
                    },
                    placeholder: {
                        ProgressView()
                            .frame(height: 100)
                    }
                )
                .shadow(radius: 10)

                // Text
                if let alt = country.flags.alt {
                    Text(verbatim: alt)
                        .italic()
                        .padding()
                }
            }
            Spacer()
        }
        #if os(tvOS)
        .focusable()
        #endif

    }

}

// MARK: - Previews

struct CountryViewFlag_Previews: PreviewProvider {

    static var previews: some View {

        CountryViewFlag(country: .italy)

    }

}
