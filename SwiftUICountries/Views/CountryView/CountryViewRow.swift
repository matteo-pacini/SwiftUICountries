//
//  CountryViewRow.swift
//  SwiftUICountries
//
//  Created by Matteo Pacini on 09/03/2023.
//

import SwiftUI

// MARK: - Views

struct CountryViewRow: View {

    let left: String?
    let right: String

    var body: some View {
        HStack {
            if let left {
                Text(left).bold()
                Spacer()
            }
            if left != nil {
                Text(right)
            } else {
                Text(right).frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }

}

struct CountryViewRowLink<Destination>: View where Destination: View {

    let left: String
    let right: String
    let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(left).bold()
                Spacer()
                Text(right)
            }
        }

    }

}

// MARK: - Previews

struct CountryViewRow_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            List {
                Section("Left and right row") {
                    CountryViewRow(left: "Title", right: "Subtitle")
                }
                Section("Right-only row") {
                    CountryViewRow(left: nil, right: "Subtitle")
                }
                Section("Row with link") {
                    CountryViewRowLink(left: "Title", right: "Subtitle") {
                        EmptyView()
                    }
                }
            }
        }

    }
}
