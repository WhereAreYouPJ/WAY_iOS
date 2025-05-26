//
//  PlaceMapView.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import SwiftUI

enum ConfirmLocationPresentationMode {
    case fromSearch // SearchLocationView에서 온 경우
    case fromFavorites // CreateScheduleView의 즐겨찾기에서 온 경우
}

// TODO: 앱 처음 실행시 지도 안보이는 문제에 대해, 다른 장소 선택했다가 지도 안보였던 장소 다시 선택하면 잘 보임. 대체 왜지!?!??
struct ConfirmLocationView: View {
    @StateObject var viewModel: ConfirmLocationViewModel
    var dismissAction: () -> Void
    var backToSearchAction: (() -> Void)?
    let presentationMode: ConfirmLocationPresentationMode
    
    init(
        location: Location,
        presentationMode: ConfirmLocationPresentationMode = .fromFavorites,
        dismissAction: @escaping () -> Void,
        backToSearchAction: (() -> Void)? = nil
    ) {
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
        self.backToSearchAction = backToSearchAction
        self.presentationMode = presentationMode
        
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
                
                locationDetailsView()
            }
            
            DismissButtonView(isShownView: .constant(true)) {
//                dismissAction()
                handleBackButtonTap()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.isFavoriteLocation()
            print("장소: \(viewModel.location.location), 위치: \(viewModel.location.streetName)")
        }
    }
    
    private func handleBackButtonTap() {
        switch presentationMode {
        case .fromSearch: // 위치검색에서 온 경우 - SearchLocationView로 돌아가기
            backToSearchAction?()
        case .fromFavorites: // 즐겨찾기에서 온 경우 - CreateScheduleView로 돌아가기
            dismissAction()
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
