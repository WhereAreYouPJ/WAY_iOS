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
    @Binding var location: Location
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            PlaceDetailsView(location: $location) {
                path.removeLast(path.count)  // MARK: Clear the navigation stack
            }
        }
    }
}

struct PlaceDetailsView: View {
    @Binding var location: Location
    let onConfirm: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(location.location)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Image("icon-bookmark")
            }
            
            Divider()
            Button(action: onConfirm) {
                Text("확인")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.brandColor))
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
        .padding(20)
    }
}

#Preview {
    PlaceMapView(location: .constant(Location(location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526)), path: .constant(NavigationPath()))
}
