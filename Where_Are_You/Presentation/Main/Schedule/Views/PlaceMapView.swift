//
//  PlaceMapView.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import SwiftUI
import MapKit

struct PlaceMapView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var place: Place?
    @Binding var path: NavigationPath
    
//    init(place: Place) {
//        self.place = place
//        
//        _region = State(initialValue: MKCoordinateRegion(
//            center: place.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        ))
//    }
//    
    var body: some View {
        ZStack(alignment: .topLeading) {
//            VStack(spacing: 0) {
//                Map(coordinateRegion: $region, annotationItems: [place]) { place in
//                    MapMarker(coordinate: place.coordinate, tint: .red)
//                }
//                .edgesIgnoringSafeArea(.top)
//                
//                PlaceDetailsView(place: place, address: $address) {
//                    location = place.location
//                    x = place.coordinate.longitude
//                    y = place.coordinate.latitude
//                    streetName = address
//                    path.removeLast(path.count)  // MARK: Clear the navigation stack
//                }
//            }
//            
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.black)
//                    .padding()
//                    .background(Color.white.opacity(0.8))
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//            }
//            .padding(20)
        }
//        .navigationBarHidden(true)
//        .onAppear {
//            fetchAddress()
//        }
    }
//    
//    private func fetchAddress() {
//        let geocoder = CLGeocoder()
//        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            if let error = error {
//                print("Reverse geocoding error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let placemark = placemarks?.first {
//                let addressComponents = [
//                    placemark.thoroughfare,
//                    placemark.subThoroughfare,
//                    placemark.locality,
//                    placemark.subLocality,
//                    placemark.administrativeArea,
//                    placemark.postalCode,
//                    placemark.country
//                ].compactMap { $0 }
//                
//                address = addressComponents.joined(separator: " ")
//            }
//        }
//    }
}

//struct PlaceDetailsView: View {
//    let place: Place
//    @Binding var address: String
//    let onConfirm: () -> Void
//    
//    var body: some View {
//        VStack {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(place.location)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    Text(address.isEmpty ? "주소를 가져오는 중..." : address)
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                Spacer()
//                Image("icon-bookmark")
//            }
//            
//            Divider()
//            Button(action: onConfirm) {
//                Text("확인")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color(.brandColor))
//                    .foregroundColor(.white)
//                    .cornerRadius(6)
//            }
//        }
//        .padding(20)
//    }
//}
//
//#Preview {
//    PlaceMapView(place: Place(location: "서울대입구", coordinate: CLLocationCoordinate2DMake(37.4808, 126.9526), streetName: "서울시 어쩌구 무슨대로"), location: .constant(""), streetName: .constant(""), x: .constant(0.0), y: .constant(0.0), path: .constant(NavigationPath()))
//}
