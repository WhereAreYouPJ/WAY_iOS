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
                .disabled(!viewModel.isEditable)
                
                Divider()
                    .padding(.bottom, 16)
                
                ReadonlyDateTimeContainer(
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
                    ),
                    isEditable: viewModel.isEditable
                )
                
                //                DateAndTimeView(
                //                    isAllDay: Binding(
                //                        get: { viewModel.schedule.isAllday ?? false },
                //                        set: { viewModel.schedule.isAllday = $0 }
                //                    ),
                //                    startTime: Binding(
                //                        get: { viewModel.schedule.startTime },
                //                        set: { viewModel.schedule.startTime = $0 }
                //                    ),
                //                    endTime: Binding(
                //                        get: { viewModel.schedule.endTime },
                //                        set: { viewModel.schedule.endTime = $0 }
                //                    )
                //                )
                //                .disabled(!viewModel.isEditable)
                
                AddPlaceView(viewModel: viewModel.createViewModel, path: $path)
                    .disabled(!viewModel.isEditable)
                
                AddFriendsView(selectedFriends: $viewModel.createViewModel.selectedFriends, path: $path)
                    .disabled(!viewModel.isEditable)
                
                SetColorView(color: $viewModel.createViewModel.color)
                    .disabled(!viewModel.isEditable)
                
                MemoView(memo: $viewModel.createViewModel.memo)
                    .disabled(!viewModel.isEditable)
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
                    if viewModel.isEditable {
                        Button("수정") {
                            viewModel.updateSchedule()
                            dismiss()
                        }
                        .foregroundStyle(viewModel.schedule.title.isEmpty ? Color.gray : Color.red)
                        .disabled(viewModel.schedule.title.isEmpty)
                    }
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

struct ReadonlyDateTimeContainer: View {
    @Binding var isAllDay: Bool
    @Binding var startTime: Date
    @Binding var endTime: Date
    var isEditable: Bool
    @State private var showingFeedback = false
    
    private var allDayBinding: Binding<Bool> {
            Binding(
                get: { isAllDay },
                set: { newValue in
                    if isEditable {
                        isAllDay = newValue
                    }
                }
            )
        }
    
    var body: some View {
        ZStack {
            VStack {
                DateAndTimeView(
                    isAllDay: allDayBinding,
                    startTime: $startTime,
                    endTime: $endTime
                )
            }
            // 편집 불가능할 때만 오버레이 추가
            if !isEditable {
                // Toggle 부분을 제외한 DatePicker 영역만 커버하는 오버레이
                VStack {
                    // Toggle 높이만큼 투명 공간
                    Color.clear
                        .frame(height: 50)
                    
                    // DatePicker 영역 커버
                    Rectangle()
                        .fill(Color.white.opacity(0.001))
                        .allowsHitTesting(true)
                        .onTapGesture {
                            showingFeedback = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showingFeedback = false
                            }
                        }
                }
                
                // 피드백 메시지
                if showingFeedback {
                    VStack {
                        Spacer()
                        HStack {
                            Image("icon-information")
                            Text("그룹 일정은 생성자만 수정할 수 있습니다")
                                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 12)))
                                .foregroundStyle(.red)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: showingFeedback)
                    }
                }
            }
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
