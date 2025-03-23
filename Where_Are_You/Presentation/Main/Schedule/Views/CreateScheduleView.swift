//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CreateScheduleView: View {
    @StateObject var viewModel: CreateScheduleViewModel
    @StateObject var searchFriendsViewModel: SearchFriendsViewModel = {
        let friendRepository = FriendRepository(friendService: FriendService())
        let getFriendUseCase = GetFriendUseCaseImpl(friendRepository: friendRepository)
        
        let memberRepository = MemberRepository(memberService: MemberService())
        let memberDetailsUseCase = MemberDetailsUseCaseImpl(memberRepository: memberRepository)
        
        let friendsViewModel = FriendsViewModel(getFriendUseCase: getFriendUseCase, memberDetailsUseCase: memberDetailsUseCase)
        
        return SearchFriendsViewModel(
            friendsViewModel: friendsViewModel,
            getFriendUseCase: getFriendUseCase)
    }()
    
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    
    @State private var showSearchLocation = false
    @State private var showConfirmLocation = false
    @State private var showSearchFriends = false
    
    @State private var selectedLocationForConfirm: Location?
    
    init(viewModel: CreateScheduleViewModel? = nil) {
        let scheduleRepository = ScheduleRepository(scheduleService: ScheduleService())
        let postScheduleUseCase = PostScheduleUseCaseImpl(scheduleRepository: scheduleRepository)
        
        let locationRepository = LocationRepository(locationService: LocationService())
        let getFavoriteLocationUseCase = GetLocationUseCaseImpl(locationRepository: locationRepository)
        
        let geocodeLocationUseCase = GeocodeLocationUseCaseImpl()
        
        let defaultViewModel = CreateScheduleViewModel(
            postScheduleUseCase: postScheduleUseCase,
            getFavoriteLocationUseCase: getFavoriteLocationUseCase,
            geocodeLocationUseCase: geocodeLocationUseCase
        )
        
        _viewModel = StateObject(wrappedValue: viewModel ?? defaultViewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            mainContent
                .toolbar {
                    toolbarContent
                }
                .navigationTitle("일정 추가")
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $showSearchLocation) {
                    SearchLocationView(
                        selectedLocation: $viewModel.place,
                        showConfirmLocation: $showConfirmLocation,
                        selectedLocationForConfirm: $selectedLocationForConfirm,
                        dismissAction: { showSearchLocation = false }
                    )
                }
                .fullScreenCover(isPresented: $showConfirmLocation) {
                    if let location = selectedLocationForConfirm {
                        ConfirmLocationView(
                            location: location,
                            dismissAction: {
                                showConfirmLocation = false
                                viewModel.getFavoriteLocation()
                            }
                        )
                    }
                }
                .fullScreenCover(isPresented: $showSearchFriends) {
                    searchFriendsView
                }
        }
        .onAppear {
            viewModel.getFavoriteLocation()
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
                TextField("", text: $viewModel.title, prompt: Text("일정명을 작성해주세요.").foregroundColor(Color(.color118)))
                
                Divider()
                    .padding(.bottom, 16)
                
                DateAndTimeView(
                    isAllDay: $viewModel.isAllDay,
                    startTime: $viewModel.startTime,
                    endTime: $viewModel.endTime
                )
                
                AddPlaceView(
                    viewModel: viewModel,
                    showSearchLocation: $showSearchLocation,
                    showConfirmLocation: $showConfirmLocation,
                    selectedLocationForConfirm: $selectedLocationForConfirm
                )
                
                AddFriendsView(
                    showSearchFriends: $showSearchFriends,
                    selectedFriends: $viewModel.selectedFriends
                )
                
                SetColorView(color: $viewModel.color)
                
                MemoView(memo: $viewModel.memo)
            })
            .padding(15)
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("취소", role: .cancel) {
                    dismiss()
                }
                .foregroundStyle(Color.red)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("추가") {
                    viewModel.postSchedule()
                    if viewModel.isSuccess {
                        dismiss()
                    } else {
                        dismiss()
                    }
                }
                .foregroundStyle(viewModel.title.isEmpty ? Color.gray : Color.red)
                .disabled(viewModel.title.isEmpty)
            }
        }
    }
    
    private var searchFriendsView: some View {
        NavigationStack {
            SearchFriendsView(
                viewModel: searchFriendsViewModel,
                selectedFriends: $viewModel.selectedFriends
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("친구 검색")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSearchFriends = false
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.gray)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        viewModel.selectedFriends = searchFriendsViewModel.confirmSelection()
                        showSearchFriends = false
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
}

struct DateAndTimeView: View {
    @Binding var isAllDay: Bool
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    var body: some View {
        Toggle(isOn: $isAllDay, label: {
            Text("하루 종일")
        })
        
        if isAllDay {
            HStack {
                Image("icon-information")
                Text("위치 확인하기 기능이 제공되지 않습니다.")
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 12)))
                    .foregroundStyle(.red)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
        
        Divider()
        
        DatePicker("시작", selection: $startTime, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
        
        Divider()
        
        DatePicker("종료", selection: $endTime, in: startTime..., displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
        
        Divider()
            .padding(.bottom, 20)
    }
}

struct AddPlaceView: View {
    @ObservedObject var viewModel: CreateScheduleViewModel
    @Binding var showSearchLocation: Bool
    @Binding var showConfirmLocation: Bool
    @Binding var selectedLocationForConfirm: Location?
    
    
    var body: some View {
        Text("위치추가")
        
        Divider()
        
        HStack {
            Image("icon-place")
            if let selectedPlace = viewModel.place { // 위치가 선택된 경우
                HStack {
                    Text(selectedPlace.location)
                        .lineLimit(1)
                        .onTapGesture {
                            selectedLocationForConfirm = selectedPlace
                            showConfirmLocation = true
                        }
                }
                
                Spacer()
                
                Button(action: { // 위치 선택 취소
                    viewModel.place = nil
                }, label: {
                    CancellationView()
                })
            } else { // 위치가 선택되지 않은 경우
                Text("위치 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        showSearchLocation = true
                    }
            }
        }
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.favPlaces) { favPlace in
                    FavoritePlaceCell(place: favPlace) {
                        viewModel.geocodeSelectedLocation(favPlace) { geocodedLocation in
                            viewModel.place = geocodedLocation
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct FavoritePlaceCell: View {
    let place: Location
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(place.location)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.blackF0))
                )
                .foregroundColor(.primary)
        }
    }
}

struct AddFriendsView: View {
    @Binding var showSearchFriends: Bool
    @Binding var selectedFriends: [Friend]
    
    var body: some View {
        Text("친구추가")
        
        Divider()
        
        HStack {
            Image("icon-invitation")
            if selectedFriends.isEmpty {
                Text("친구 추가")
                    .foregroundStyle(Color(.color118))
            } else {
                let count = selectedFriends.count
                ForEach(0..<min(3, count), id: \.self) { idx in
                    if idx < count - 1 {
                        Text(selectedFriends[idx].name + ", ")
                    } else {
                        Text(selectedFriends[idx].name)
                    }
                }
                
                if count > 3 {
                    Text("외 " + String(count - 3) + "명")
                }
                
                Spacer()
                
                Button(action: {
                    selectedFriends.removeAll()
                }, label: {
                    CancellationView()
                })
            }
        }
        .onTapGesture {
            showSearchFriends = true
        }
        .padding(.bottom, 20)
    }
}

struct CancellationView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: LayoutAdapter.shared.scale(value: 18), height: LayoutAdapter.shared.scale(value: 18))
                .foregroundColor(Color(.color235))
            
            Image("icon-delete")
                .resizable()
                .frame(width: LayoutAdapter.shared.scale(value: 18), height: LayoutAdapter.shared.scale(value: 18))
                .opacity(0.8)
        }
        .padding(.trailing, 4)
    }
}

struct SetColorView: View {
    @Binding var color: String
    
    let colors: [(Color, String)] = [
        (.colorRed, "red"),
        (.colorYellow, "yellow"),
        (.colorGreen, "green"),
        (.colorBlue, "blue"),
        (.colorViolet, "violet"),
        (.colorPink, "pink")
    ]
    
    var body: some View {
        Text("일정컬러")
        
        Divider()
        
        HStack {
            ForEach(colors, id: \.1) { colorPair in
                Circle()
                    .fill(colorPair.0)
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        color = colorPair.1
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: color == colorPair.1 ? 2 : 0)
                    )
            }
        }
        .padding(.bottom, 20)
    }
}

struct MemoView: View {
    @Binding var memo: String
    let maxLength = 500
    
    var body: some View {
        HStack {
            Text("메모")
            
            Spacer()
            
            Text("\(memo.count)/\(maxLength)")
                .foregroundColor(memo.count == maxLength ? .red : .gray)
        }
        Divider()
        
        ScrollView {
            ZStack(alignment: .topLeading) {
                if memo.isEmpty {
                    Text("메모를 작성해주세요.")
                        .foregroundStyle(memo.isEmpty ? Color(.color118) : .clear)
                        .padding(10)
                }
                
                TextEditor(text: $memo)
                    .modifier(MaxLengthModifier(text: $memo, maxLength: maxLength))
                    .frame(height: LayoutAdapter.shared.scale(value: 100))
                    .padding(2)
                    .opacity(memo.isEmpty ? 0.1 : 1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.color212))
            )
        }
    }
}

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
    }
}

#Preview {
    CreateScheduleView()
}

