//
//  FriendsLocationView.swift
//  Where_Are_You
//
//  Created by juhee on 30.11.24.
//

import SwiftUI

struct FriendsLocationView: View {
    @Binding var isShownView: Bool
    @Binding var schedule: Schedule
    @State private var currentLocation: Location?
    
    @ObservedObject var viewModel: FriendsLocationViewModel = {
        let coordinateRepository = CoordinateRepository(coordinateService: CoordinateService())
        let postCoordinateUseCase = PostCoordinateUseCaseImpl(coordinateRepository: coordinateRepository)
        let getCoordinateUseCase = GetCoordinateUseCaseImpl(coordinateRepository: coordinateRepository)
        
        return FriendsLocationViewModel(postCoordinateUseCase: postCoordinateUseCase, getCoordinateUseCase: getCoordinateUseCase)
    }()
    
    var body: some View {
        ZStack {
            if let location = currentLocation {
                MapPinView(myLocation: .constant(location))
            }
            
            DismissButtonView(isShownView: $isShownView)
        }
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        .onAppear {
            viewModel.startUpdatingLocation()
        }
        .onChange(of: viewModel.userLatitude) { _, _ in
            updateLocation()
        }
        .onChange(of: viewModel.userLongitude) { _, _ in
            updateLocation()
        }
    }
    
    private func updateLocation() {
        if viewModel.userLatitude != 0 && viewModel.userLongitude != 0 {
            currentLocation = Location(
                sequence: 0,
                location: "현재 위치",
                streetName: "",
                x: viewModel.userLongitude,
                y: viewModel.userLatitude
            )
        }
    }
}

struct DismissButtonView: View {
    @Binding var isShownView: Bool
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    self.isShownView.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 4))
                            .stroke(Color(.brandColor), lineWidth: LayoutAdapter.shared.scale(value: 1.5))
                            .background(Color(.color249))
                            .frame(width: LayoutAdapter.shared.scale(value: 32), height: LayoutAdapter.shared.scale(value: 32))
                            .shadow(color: Color(.color153), radius: 5, x: 3, y: 3)
                        
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color(.color34))
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding(LayoutAdapter.shared.scale(value: 15))
    }
}

#Preview {
    FriendsLocationView(isShownView: .constant(true), schedule: .constant(Schedule(scheduleSeq: 1, title: "디큐브", startTime: Date.now, endTime: Date.now, color: "red")))
}
