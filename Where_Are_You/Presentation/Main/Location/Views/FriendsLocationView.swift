//
//  FriendsLocationView.swift
//  Where_Are_You
//
//  Created by juhee on 30.11.24.
//

import SwiftUI

struct FriendsLocationView: View { // TODO: 앱을 재시작해야만 일정에 초대된 친구가 업데이트 되는 문제
    @Environment(\.dismiss) private var dismiss
    @Binding var schedule: Schedule
    var currentLocation: LongLat?
    
    @ObservedObject var viewModel: FriendsLocationViewModel = {
        let coordinateRepository = CoordinateRepository(coordinateService: CoordinateService())
        let postCoordinateUseCase = PostCoordinateUseCaseImpl(coordinateRepository: coordinateRepository)
        let getCoordinateUseCase = GetCoordinateUseCaseImpl(coordinateRepository: coordinateRepository)
        
        return FriendsLocationViewModel(postCoordinateUseCase: postCoordinateUseCase, getCoordinateUseCase: getCoordinateUseCase)
    }()
    
    var body: some View {
        ZStack {
            MapPinView(myLocation: $viewModel.myLocation, friendsLocation: $viewModel.friendsLocation)
            
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 4))
                                .fill(Color.white)
                                .frame(width: LayoutAdapter.shared.scale(value: 32), height: LayoutAdapter.shared.scale(value: 32))
                                .shadow(color: .black.opacity(0.15), radius: 0, x: 2, y: 2)
                            
                            Image("icon-arrow-left")
                                .foregroundColor(Color.brandMain)
                        }
                    })
                    Spacer()
                }
                Spacer()
            }
            .padding(LayoutAdapter.shared.scale(value: 15))
        }
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        .onAppear {
            viewModel.startUpdatingLocation()
            viewModel.getCoordinate(schedule: schedule)
            viewModel.startUpdatingFriendsLocation(schedule: schedule)
        }
        .onDisappear {
            viewModel.stopUpdatingLocation()
        }
        .onChange(of: viewModel.myLocation.x) { _, _ in
            viewModel.postCoordinate(scheduleSeq: schedule.scheduleSeq)
        }
        .onChange(of: viewModel.myLocation.y) { _, _ in
            viewModel.postCoordinate(scheduleSeq: schedule.scheduleSeq)
        }
    }
}

struct DismissButtonView: View {
    @Binding var isShownView: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            VStack {
                Button(action: action) {
                    ZStack {
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 4))
                            .fill(Color.white)
                            .frame(width: LayoutAdapter.shared.scale(value: 32), height: LayoutAdapter.shared.scale(value: 32))
                            .shadow(color: .black.opacity(0.15), radius: 0, x: 2, y: 2)
                        
                        Image("icon-arrow-left")
                            .foregroundColor(Color.brandMain)
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
//    FriendsLocationView(isShownView: .constant(true), schedule: .constant(Schedule(scheduleSeq: 1, title: "디큐브", startTime: Date.now, endTime: Date.now, color: "red")))
    FriendsLocationView(schedule: .constant(Schedule(scheduleSeq: 1, title: "디큐브", startTime: Date.now, endTime: Date.now, color: "red")))
}
