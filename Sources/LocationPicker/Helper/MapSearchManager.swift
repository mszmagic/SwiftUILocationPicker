//
//  MapSearchManager.swift
//  SwiftUIMapLocationPicker
//
//  Created by Shunzhe Ma on R 3/01/19.
//

import Foundation
import MapKit

public class MapSearchManager {
    
    static public let shared = MapSearchManager()
    
    public func searchLocation(name: String, mapRegion: MKCoordinateRegion, foundPlaces: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        request.region = mapRegion
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let items = response?.mapItems {
                foundPlaces(items)
            } else {
                foundPlaces([])
            }
        }
    }
    
    // [MKMapItem] -> [MKPointAnnotation]
    public func getAnnotationItems(forMapItems: [MKMapItem]) -> [MKPointAnnotation] {
        return forMapItems.map { mapItem -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = mapItem.name ?? ""
            annotation.coordinate = mapItem.placemark.coordinate
            return annotation
        }
    }
    
}
