//
//  ScheduleDetailView.swift
//  Where_Are_You
//
//  Created by juhee on 05.11.24.
//

import SwiftUI

struct ScheduleDetailView: View {
    @StateObject var viewModel: ScheduleDetailViewModel
    @StateObject var createViewModel: CreateScheduleViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    @State private var showFriendsLocation = false // MARK: 친구 위치 실시간 확인 테스트용
    
    @State private var showSearchLocation = false
    @State private var showConfirmLocation = false
    @State private var showSearchFriends = false
    @State private var selectedLocationForConfirm: Location?
    
    var schedule: Schedule
    
    init(
        schedule: Schedule,
        viewModel: ScheduleDetailViewModel? = nil,
        createViewModel: CreateScheduleViewModel? = nil
    ) {
        self.schedule = schedule
        
        let scheduleRepository = ScheduleRepository(scheduleService: ScheduleService())
        let getScheduleUseCase = GetScheduleUseCaseImpl(scheduleRepository: scheduleRepository)
        let putScheduleUseCase = PutScheduleUseCaseImpl(scheduleRepository: scheduleRepository)
        
        _ = ScheduleDetailViewModel(
            schedule: schedule,
            getScheduleUseCase: getScheduleUseCase,
            putScheduleUseCase: putScheduleUseCase
        )
        
        _viewModel = StateObject(wrappedValue: ScheduleDetailViewModel(schedule: schedule, getScheduleUseCase: getScheduleUseCase, putScheduleUseCase: putScheduleUseCase))
        
        let postScheduleUseCase = PostScheduleUseCaseImpl(scheduleRepository: scheduleRepository)
        
        let locationRepository = LocationRepository(locationService: LocationService())
        let getFavoriteLocationUseCase = GetLocationUseCaseImpl(locationRepository: locationRepository)
        
        let geocodeLocationUseCase = GeocodeLocationUseCaseImpl()
        
        let defaultCreateViewModel = CreateScheduleViewModel(
            schedule: schedule,
            postScheduleUseCase: postScheduleUseCase,
            getFavoriteLocationUseCase: getFavoriteLocationUseCase,
            geocodeLocationUseCase: geocodeLocationUseCase
        )
        
        _createViewModel = StateObject(wrappedValue: createViewModel ?? defaultCreateViewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutAdapter.shared.scale(value: 10)) {
                    TextField(
                        "",
                        text: Binding(get: { viewModel.schedule.title },
                                      set: { viewModel.schedule.title = $0 }),
                        prompt: Text("일정명을 작성해주세요.").withBodyP2Style(color: .blackAC)
                    )
                    .disabled(!viewModel.isEditable)
                    .padding(.top, LayoutAdapter.shared.scale(value: 6))
                    .bodyP2Style(color: .black22)
                    
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
                    .disabled(!viewModel.isEditable)
                    
                    AddPlaceView(
                        viewModel: createViewModel,
                        showSearchLocation: $showSearchLocation,
                        showConfirmLocation: $showConfirmLocation,
                        selectedLocationForConfirm: $selectedLocationForConfirm
                    )
                        .disabled(!viewModel.isEditable)
                    
                    AddFriendsView(
                        showSearchFriends: $showSearchFriends,
                        selectedFriends: Binding(
                            get: { viewModel.schedule.invitedMember ?? [] },
                            set: { viewModel.schedule.invitedMember = $0 }
                        )
                    )
                    .disabled(!viewModel.isEditable)
                    
                    SetColorView(color: $createViewModel.color)
                        .disabled(!viewModel.isEditable)
                    
                    MemoView(memo: $createViewModel.memo, isEditing: $createViewModel.isEditingMemo)
                        .disabled(!viewModel.isEditable)
                    
                    // TODO: 친구 위치 실시간 확인 테스트용. 홈화면에서 기능 추가시 삭제 필요
//                    Button {
//                        self.showFriendsLocation.toggle()
//                    } label: {
//                        Text("실시간 위치 확인")
//                    }
//                    .padding(.vertical, 20)
                }
                .padding(LayoutAdapter.shared.scale(value: 16))
                .onTapGesture {
                    if !viewModel.isEditable {
                        ToastManager.shared.showToast(message: "일정을 수정할 수 없습니다.")
                    }
                }
                .fullScreenCover(isPresented: $showFriendsLocation) {
                    FriendsLocationView(isShownView: $showFriendsLocation, schedule: $viewModel.schedule)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소", role: .cancel) {
                            dismiss()
                        }
                        .bodyP3Style(color: .error)
                    }
                    ToolbarItem(placement: .primaryAction) {
//                        if viewModel.isEditable {
                            Button("수정") {
                                viewModel.updateSchedule()
                                dismiss()
                            }
                            .foregroundStyle(createViewModel.checkPostAvailable() ? Color.error : Color.gray)
                            .disabled(!createViewModel.checkPostAvailable())
//                        }
                    }
                }
                .navigationTitle("일정 수정")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .bodyP3Style(color: .black22)
        .onAppear {
            viewModel.getScheduleDetail()
            createViewModel.getFavoriteLocation()
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
        invitedMember: [Friend(memberSeq: 1, profileImage: "", name: "홍길동", isFavorite: false, memberCode: "abc12")]
    ))
}
