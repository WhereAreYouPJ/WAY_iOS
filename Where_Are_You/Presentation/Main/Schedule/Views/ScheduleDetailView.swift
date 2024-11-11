//
//  ScheduleDetailView.swift
//  Where_Are_You
//
//  Created by juhee on 05.11.24.
//

import SwiftUI

struct ScheduleDetailView: View {
    @StateObject var viewModel: ScheduleDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    var schedule: Schedule
    
    init(schedule: Schedule) {
        self.schedule = schedule
        _viewModel = StateObject(wrappedValue: ScheduleDetailViewModel(schedule: schedule))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, content: {
                TextField("",
                          text: Binding(get: { viewModel.schedule.title },
                                        set: { viewModel.schedule.title = $0 }),
                          prompt: Text("메모를 작성해주세요.").foregroundColor(Color(.color118)))
                
                Divider()
                    .padding(.bottom, 16)
                
                DateAndTimeView(
                    isAllDay: Binding(
                        get: { viewModel.schedule.isAllday ?? false },
                        set: { viewModel.schedule.isAllday = $0 }
                    ),
                    startTime: Binding(
                        get: { viewModel.schedule.startTime },
                        set: { viewModel.schedule.startTime = $0 }
                    ),
                    endTime: Binding(
                        get: { viewModel.schedule.endTime },
                        set: { viewModel.schedule.endTime = $0 }
                    )
                )
                
                AddPlaceView(viewModel: viewModel.createViewModel, path: $path)
                
                AddFriendsView(selectedFriends: $viewModel.createViewModel.selectedFriends, path: $path)
                
                SetColorView(color: $viewModel.createViewModel.color)
                
                MemoView(memo: $viewModel.createViewModel.memo)
            })
            .padding(15)
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                    .foregroundStyle(Color.red)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("수정") {
                        viewModel.updateSchedule()
                        if viewModel.isSuccess {
                            dismiss()
                        } else {
                            // TODO: 일정 생성 예외 처리 필요, 실패 경우 동작 구현
                            dismiss()
                        }
                    }
                    .foregroundStyle(viewModel.schedule.title.isEmpty ? Color.gray : Color.red)
                    .disabled(viewModel.schedule.title.isEmpty)
                }
            }
            .navigationTitle("일정 수정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .searchPlace:
                    SearchLocationView(selectedLocation: $viewModel.createViewModel.place, path: $path)
                case .searchFriends:
                    SearchFriendsView(selectedFriends: $viewModel.createViewModel.selectedFriends)
                case .confirmLocation:
                    ConfirmLocationView(location: $viewModel.createViewModel.place, path: $path)
                        .onDisappear {
                            viewModel.createViewModel.getFavoriteLocation()
                        }
                    
                }
            }
        }
        .onAppear {
            viewModel.createViewModel.getFavoriteLocation()
        }
    }
}

#Preview {
    ScheduleDetailView(schedule: Schedule(
        scheduleSeq: 1,
        title: "테스트 일정",
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        isAllday: false,
        location: Location(sequence: 1, location: "테스트 장소", streetName: "", x: 0, y: 0),
        color: "red",
        memo: "테스트 메모입니다.",
        invitedMember: [Friend(memberSeq: 1, profileImage: "", name: "홍길동")]
    ))
}
