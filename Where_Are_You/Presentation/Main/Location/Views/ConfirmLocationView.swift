//
//  PlaceMapView.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import SwiftUI

struct ConfirmLocationView: View {
    @StateObject var viewModel: ConfirmLocationViewModel
    var dismissAction: () -> Void
    
    init(location: Location, dismissAction: @escaping () -> Void) {
        let repository = LocationRepository(locationService: LocationService())
        let getLocationUseCase = GetLocationUseCaseImpl(locationRepository: repository)
        let postLocationUseCase = PostLocationUseCaseImpl(locationRepository: repository)
        let deleteLocationUseCase = DeleteLocationUseCaseImpl(locationRepository: repository)
        
        _viewModel = StateObject(wrappedValue: ConfirmLocationViewModel(
            location: location,
            getFavoriteLocationUseCase: getLocationUseCase,
            postFavoriteLocationUseCase: postLocationUseCase,
            deleteFavoriteLocationUseCase: deleteLocationUseCase
        ))
        
        self.dismissAction = dismissAction
        
        print("init ConfirmLocationView!")
    }
    
    var body: some View {
        ZStack {
            VStack {
                MapPinView(
                    myLocation: .constant(LongLat(
                        member: viewModel.member,
                        x: viewModel.location.x,
                        y: viewModel.location.y
                    )),
                    friendsLocation: .constant([])
                )
                // 임시로 MapPinView 대신 컬러 블록 사용
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(maxHeight: .infinity)
//                    .overlay(
//                        Text("지도 영역")
//                            .foregroundColor(.white)
//                    )
//                
//                Spacer()
                
                locationDetailsView()
            }
            
            DismissButtonView(isShownView: .constant(true)) {
                dismissAction()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.isFavoriteLocation()
            print("장소: \(viewModel.location.location), 위치: \(viewModel.location.streetName)")
        }
    }
    
    private func locationDetailsView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: LayoutAdapter.shared.scale(value: 4)) {
                    Text(viewModel.location.location)
                        .bodyP1Style(color: .black22)
                    Text(viewModel.location.streetName)
                        .bodyP4Style(color: .black66)
                }
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite()
                }, label: {
                    Image(viewModel.isFavorite ? "icon-bookmark-filled" : "icon-bookmark")
                })
            }
            
            Divider()
                .padding(.top, LayoutAdapter.shared.scale(value: 12))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 6))
            
            Button(action: {
                dismissAction()
            }, label: {
                Text("확인")
                    .button18Style(color: .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.brandColor))
                    .cornerRadius(LayoutAdapter.shared.scale(value: 8))
            })
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 24))
        .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
    }
}

#Preview {
    let location = Location(sequence: 0, location: "현대백화점 디큐브시티점", streetName: "서울 구로구 경인로 662", x: 126.88958060554663, y: 37.50910419634123)
    
    return ConfirmLocationView(
        location: location,
        dismissAction: {}
    )
}
