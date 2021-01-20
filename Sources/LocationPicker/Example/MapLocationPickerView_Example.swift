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
    @State var showLocationPicker: Bool = false
    var body: some View {
        NavigationView {
            Form {
                if locationName != "",
                   locationAddress != "" {
                    Section {
                        Text(locationName)
                        Text(locationAddress)
                    }
                }
                Button(action: {
                    self.showLocationPicker = true
                }, label: {
                    Text("場所を選択してください")
                })
                .sheet(isPresented: $showLocationPicker, content: {
                    LocationPicker(shouldUseUserCurrentLocation: true, onLocationSelected: { item in
                        self.showLocationPicker = false
                        self.locationName = item.name ?? ""
                        self.locationAddress = item.placemark.thoroughfare ?? ""
                        // item.placemark.coordinate
                    }, onCancelled: {
                        self.showLocationPicker = false
                    })
                })
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
