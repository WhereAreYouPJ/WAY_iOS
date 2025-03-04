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
    }
    
    var body: some View {
        ZStack {
            VStack {
                MapView(location: $viewModel.location)
                
                Spacer()
                
                locationDetailsView()
            }
            
            DismissButtonView(isShownView: .constant(true)) {
                dismissAction()
            }
        }
        .navigationBarBackButtonHidden()
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 16)))
        .onAppear {
            viewModel.isFavoriteLocation()
        }
    }
    
    private func locationDetailsView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.location.location)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 20))))
                        .foregroundColor(Color(.black44))
                    Text(viewModel.location.streetName)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14))))
                        .foregroundColor(Color(.color153))
                }
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite()
                }, label: {
                    Image(viewModel.isFavorite ? "icon-bookmark-filled" : "icon-bookmark")
                })
            }
            
            Divider()
                .padding(.top, 16)
            
            Button(action: {
                dismissAction()
            }, label: {
                Text("확인")
                    .font(Font(UIFont.pretendard(NotoSans: .semibold, fontSize: 18)))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.brandColor))
                    .foregroundColor(.white)
                    .cornerRadius(6)
            })
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    let location = Location(sequence: 0, location: "현대백화점 디큐브시티점", streetName: "서울 구로구 경인로 662", x: 126.88958060554663, y: 37.50910419634123)
    
    return ConfirmLocationView(
        location: location,
        dismissAction: {}
    )
}
