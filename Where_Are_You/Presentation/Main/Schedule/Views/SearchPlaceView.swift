//
//  SearchPlaceView.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import MapKit

struct SearchPlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: String
    @Binding var streetName: String
    @Binding var x: Double
    @Binding var y: Double
    @Binding var path: NavigationPath
    
    @State private var selectedPlace: Place?
    @State private var showPlaceMapView = false
    
    let places: [Place] = [
        .init(name: "서울대입구", coordinate: CLLocationCoordinate2D(latitude: 37.4808, longitude: 126.9526), address: ""),
        .init(name: "여의도공원", coordinate: CLLocationCoordinate2D(latitude: 37.5268, longitude: 126.9244), address: ""),
        .init(name: "올림픽체조경기장", coordinate: CLLocationCoordinate2D(latitude: 37.5221, longitude: 127.1259), address: ""),
        .init(name: "재즈바", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), address: ""),
        .init(name: "신도림", coordinate: CLLocationCoordinate2D(latitude: 37.5088, longitude: 126.8912), address: ""),
        .init(name: "망원한강공원", coordinate: CLLocationCoordinate2D(latitude: 37.5545, longitude: 126.8964), address: ""),
        .init(name: "부천시청", coordinate: CLLocationCoordinate2D(latitude: 37.5037, longitude: 126.7661), address: "")
    ]
    
    @State private var searchText = ""
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        } else {
            return places.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("장소 검색", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal)
                .padding(.top)
            
            List(filteredPlaces) { place in
                Text(place.name)
                    .onTapGesture {
                        selectedPlace = place
                        showPlaceMapView = true
                    }
            }
        }
        .navigationTitle("장소 검색")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showPlaceMapView) {
            if let place = selectedPlace {
                PlaceMapView(place: place, location: $location, streetName: $streetName, x: $x, y: $y, path: $path)
            }
        }
    }
}

#Preview {
    SearchPlaceView(location: .constant(""), streetName: .constant(""), x: .constant(0.0), y: .constant(0.0), path: .constant(NavigationPath()))
}
