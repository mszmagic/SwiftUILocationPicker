//
//  ContentView.swift
//  SwiftUIMapLocationPicker
//
//  Created by Shunzhe Ma on R 3/01/19.
//

import SwiftUI

struct LocationPicker_Example: View {
    @State var locationName: String = ""
    @State var locationAddress: String = ""
    var body: some View {
        NavigationView {
            Form {
                Text(locationName)
                Text(locationAddress)
                NavigationLink(
                    destination: LocationPicker(shouldUseUserCurrentLocation: true, onLocationSelected: { item in
                        self.locationName = item.name ?? ""
                        self.locationAddress = item.placemark.thoroughfare ?? ""
                        // item.placemark.coordinate
                    }),
                    label: {
                        Text("場所を選択してください")
                    })
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
