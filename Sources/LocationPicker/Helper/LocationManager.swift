//
//  LocationManager.swift
//  SwiftUIMapLocationPicker
//
//  Created by Shunzhe Ma on R 3/01/19.
//

import Foundation
import CoreLocation

internal class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published public var userLocation: CLLocation?

    public let locationManager = CLLocationManager()

    init(accuracy: CLLocationAccuracy) {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = accuracy
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}
