//
//  PlaceMapView.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import SwiftUI

struct ConfirmLocationView: View {
    @StateObject var viewModel = ConfirmLocationViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: Location
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            MapView(location: $location)
            
            Spacer()
            
            locationDetailsView()
        }
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        .onAppear {
            viewModel.isFavoriteLocation(location: location) { isFavorite in
                viewModel.isFavorite = isFavorite
            }
        }
    }
    
    private func locationDetailsView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(location.location)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 20)))
                        .foregroundColor(Color(.color68))
                    Text(location.streetName)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 14)))
                        .foregroundColor(Color(.color153))
                }
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(location: location) { success in
                        if success {
                            // Toggle was successful, update UI if needed
                        } else {
                            // Handle error
                            print("즐겨찾기 토글 실패")
                        }
                    }
                }) {
                    Image(viewModel.isFavorite ? "icon-bookmark-filled" : "icon-bookmark")
                }
            }
            
            Divider()
                .padding(.top, 16)
            
            Button(action: {
                path.removeLast(path.count)
            }) {
                Text("확인")
                    .font(Font(UIFont.pretendard(NotoSans: .semibold, fontSize: 18)))
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
    ConfirmLocationView(location: .constant(Location(sequence: 0, location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526)), path: .constant(NavigationPath()))
}
