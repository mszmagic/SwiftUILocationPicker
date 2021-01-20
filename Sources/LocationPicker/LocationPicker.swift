//
//  MapLocationPickerView.swift
//  InkMemo
//
//  Created by Shunzhe Ma on R 3/01/19.
//

import SwiftUI
import MapKit
import SwiftUILibrary

extension MKMapItem: Identifiable { }
extension MKPointAnnotation: Identifiable { }

public struct LocationPicker: View {
    
    @State private var mapSearchTerm: String = ""
    @State private var mapRegion: MKCoordinateRegion
    
    // ユーザーの現在地を取得するために使用
    @ObservedObject private var location = LocationManager(accuracy: kCLLocationAccuracyHundredMeters)
    
    // マップ上の全検索結果を表示するために使用
    @State private var allSearchResults: [MKMapItem] = []
    @State private var annotationItems: [MKPointAnnotation] = []
    
    private var shouldUseUserCurrentLocation: Bool
    private var onLocationSelected: (MKMapItem) -> Void
    
    /**
     ユーザーが検索結果を選択すると、それをマップ上で閲覧するか、`ActionSheet` を通じて選ぶかのオプションを表示します
     */
    @State private var selectedResultItem: MKMapItem?
    
    /**
     ユーザーが場所を選択した時点で `dismiss` します。
     */
    @Environment(\.presentationMode) private var presentationMode
    
    /**
     検索は、ユーザーがキーボードのリターンキーをクリックしたとき（キーボードが解除されたとき）に実行されます。
     */
    private var keyboardHiddenNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    
    public init(shouldUseUserCurrentLocation: Bool, onLocationSelected: @escaping (MKMapItem) -> Void, initialMapDisplayCoordinate: CLLocationCoordinate2D = .init(latitude: 35.68110, longitude: 139.76687)) {
        self.shouldUseUserCurrentLocation = shouldUseUserCurrentLocation
        self._mapRegion = .init(initialValue: .init(center: initialMapDisplayCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        self.onLocationSelected = onLocationSelected
    }
    
    public var body: some View {
        
        VStack {
            
            MapView(mapRegion: $mapRegion, annotationItems: $annotationItems)
                .addOverlay({
                    SearchTextFieldView(searchText: $mapSearchTerm)
                }, floatingViewHeight: 100, position: .top, backgroundColor: .clear, verticalOffset: 20)
                .addOverlay({
                    if self.allSearchResults.count > 0 {
                        List(self.allSearchResults, id: \.self) { result in
                            Button(action: {
                                self.selectedResultItem = result
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(result.name ?? "")
                                        .font(.headline)
                                    Text(result.placemark.thoroughfare ?? "")
                                }
                            })
                        }
                        .clipped()
                        .cornerRadius(20)
                        .frame(height: 260)
                        .padding()
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        Text("テキストフィールドにキーワードを入力し、キーボードのリターンキーをクリックして始めます。")
                            .padding()
                            .font(.headline)
                            .offset(y: -20)
                    }
                }, floatingViewHeight: 300, position: .bottom, backgroundColor: .clear)
                .actionSheet(item: $selectedResultItem, content: { result in
                    ActionSheet(title: Text(result.name ?? ""), message: Text(result.placemark.thoroughfare ?? ""), buttons: [
                        .default(Text("地図上に表示する"), action: {
                            self.mapRegion = .init(center: result.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            self.annotationItems = MapSearchManager.shared.getAnnotationItems(forMapItems: [result])
                        }),
                        .default(Text("この場所を選択する"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.onLocationSelected(result)
                        }),
                        .cancel()
                    ])
                })
                .onChange(of: self.location.userLocation, perform: { value in
                    guard annotationItems.count == 0 else { return }
                    guard let userLocation = value?.coordinate else { return }
                    self.mapRegion = .init(center: userLocation, span: self.mapRegion.span)
                })
                .onAppear(perform: {
                    if shouldUseUserCurrentLocation {
                        location.locationManager.requestWhenInUseAuthorization()
                        location.locationManager.requestLocation()
                    }
                })
                .onDisappear(perform: {
                    location.locationManager.stopUpdatingLocation()
                })
                .onReceive(keyboardHiddenNotification, perform: { _ in
                    MapSearchManager.shared.searchLocation(name: self.mapSearchTerm, mapRegion: self.mapRegion) { items in
                        self.allSearchResults = items
                    }
                })
            
        }
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
}

/**
 与えられた領域と注釈項目（`MKPointAnnotation`として名前と座標集合を持つ）を持つ地図を表示する地図表示。
 */
public struct MapView: View {
    
    @Binding private var mapRegion: MKCoordinateRegion
    @Binding private var annotationItems: [MKPointAnnotation]
    
    public init(mapRegion: Binding<MKCoordinateRegion>, annotationItems: Binding<[MKPointAnnotation]>) {
        self._mapRegion = mapRegion
        self._annotationItems = annotationItems
    }
    
    public var body: some View {
        
        Map(coordinateRegion: $mapRegion, annotationItems: self.annotationItems) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                VStack {
                    Image(systemName: "building.2.crop.circle.fill")
                        .font(.system(size: 30))
                    Text(annotation.title ?? "")
                        .font(.headline)
                }
            }
        }.ignoresSafeArea()
        
    }
    
}
