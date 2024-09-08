//
//  PlaceMapView.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import SwiftUI
import MapKit

struct ConfirmLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: Location
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            MapView()
            
            Spacer()
            
            locationDetailsView()
        }
    }
    
    private func locationDetailsView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(location.location)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(location.streetName)
                }
                Spacer()
                Image("icon-bookmark")
            }
            
            Divider()
            Button(action: {
                path.removeLast(path.count)  // 네비게이션 스택을 초기화하여 CreateScheduleView로 돌아갑니다.
            }) {
                Text("확인")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.brandColor))
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    ConfirmLocationView(location: .constant(Location(location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526)), path: .constant(NavigationPath()))
}
