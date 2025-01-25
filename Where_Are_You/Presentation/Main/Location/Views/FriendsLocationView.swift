//
//  FriendsLocationView.swift
//  Where_Are_You
//
//  Created by juhee on 30.11.24.
//

import SwiftUI

struct FriendsLocationView: View { // TODO: 앱을 재시작해야만 일정에 초대된 친구가 업데이트 되는 문제
    @Binding var isShownView: Bool
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
            
            DismissButtonView(isShownView: $isShownView)
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
                            .foregroundColor(Color(.black22))
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
