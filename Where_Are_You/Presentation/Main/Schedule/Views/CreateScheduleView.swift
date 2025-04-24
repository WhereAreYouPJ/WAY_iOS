//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

// TODO: 2. 메모 글자수 초과시 토스트 메시지
// TODO: 3. 위치 뒤로가기 스택 수정
// TODO: 4. 필수 항목 누락이 있을 때 추가 버튼 터치 시 토스트 메시지
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
                    } else {
                        // 이 경우는 발생하지 않아야 함
                        Text("다시 시도해주세요.")
                            .onAppear {
                                print("위치 정보 없음 - 이 메시지가 표시되면 안됨")
                                DispatchQueue.main.async {
                                    showConfirmLocation = false
                                }
                            }
                    }
                }
                .fullScreenCover(isPresented: $showSearchFriends) {
                    searchFriendsView
                }
        }
        .bodyP3Style(color: .black22)
        .onAppear {
            viewModel.getFavoriteLocation()
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: LayoutAdapter.shared.scale(value: 10)) {
                    TextField(
                        "",
                        text: $viewModel.title,
                        prompt: Text("일정명을 입력해주세요.")
                            .withBodyP2Style(color: .blackAC)
                    )
                    .padding(.top, LayoutAdapter.shared.scale(value: 6))
                    .bodyP2Style(color: .black22)
                    
                    Divider()
                        .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
                    
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
                    
                    MemoView(memo: $viewModel.memo, isEditing: $viewModel.isEditingMemo)
                        .id("memoView")
                }
                .padding(LayoutAdapter.shared.scale(value: 16))
                .onChange(of: viewModel.isEditingMemo) { _, isEditing in
                    if isEditing {
                        withAnimation {
                            proxy.scrollTo("memoView", anchor: .top)
                        }
                    }
                }
            } // ScrollViewReader
        } // ScrollView
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("취소", role: .cancel) {
                    dismiss()
                }
                .foregroundStyle(Color.error)
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
                .foregroundStyle(viewModel.checkPostAvailable() ? Color.error : Color.gray)
                .disabled(!viewModel.checkPostAvailable())
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
                    Button("적용") {
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
        VStack(alignment: .leading, spacing: LayoutAdapter.shared.scale(value: 4)) {
            Toggle(isOn: $isAllDay, label: {
                Text("하루 종일")
            })
            
            if isAllDay {
                HStack {
                    Image("icon-information")
                    Text("위치 확인하기 기능이 제공되지 않습니다.")
                        .bodyP5Style(color: .error)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        
        Divider()
        
        DatePicker("시작일", selection: $startTime, in: Date.yearRange2000To2100, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .accentColor(Color(.brandDark))
        
        Divider()
        
        DatePicker("종료일", selection: $endTime, in: Date.yearRange2000To2100, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .accentColor(Color(.brandDark))
            .onChange(of: endTime) { oldValue, newValue in
                if newValue < startTime { // 무효한 값. 종료일이 시작일보다 빠름
//                    endTime = oldValue
                    
                }
            }
        
        if startTime > endTime {
            HStack {
                Image("icon-information")
                Text("종료일은 시작일보다 빠를 수 없습니다.")
                    .bodyP5Style(color: .error)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
        
        Divider()
            .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
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
//                            selectedLocationForConfirm = selectedPlace
////                            showConfirmLocation = true
//                            print("선택된 위치: \(selectedLocationForConfirm?.location ?? "빈 값"), 좌표: \(selectedLocationForConfirm?.x ?? 0), \(selectedLocationForConfirm?.y ?? 0)")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    showConfirmLocation = true
//                                }
//                            print("showConfirmLocation", showConfirmLocation)
                            showLocationConfirmation(location: selectedPlace)
                        }
                }
                
                Spacer()
                
                Button(action: { // 위치 선택 취소
                    viewModel.place = nil
                }, label: {
                    CancellationView()
                })
            } else { // 위치가 선택되지 않은 경우
                Text("위치 검색")
                    .foregroundStyle(Color(UIColor.blackAC))
                    .onTapGesture {
                        showSearchLocation = true
                    }
            }
        }
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(Array(viewModel.favPlaces.prefix(20))) { favPlace in // 최대 20개 표시
                    FavoritePlaceCell(place: favPlace) {
//                        viewModel.geocodeSelectedLocation(favPlace) { geocodedLocation in
//                            viewModel.place = geocodedLocation
//                        }
                        viewModel.place = favPlace
                    }
                }
            }
            .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
        }
        .padding(.bottom, LayoutAdapter.shared.scale(value: 12))
    }
    
    func showLocationConfirmation(location: Location) {
        print("showLocationConfirmation 호출됨, 위치: \(location.location)")
        
        // 명시적으로 상태 업데이트
        self.selectedLocationForConfirm = location
        
        // 상태 업데이트가 완료된 후 화면 전환
        DispatchQueue.main.async {
            self.showConfirmLocation = true
        }
    }
}

struct FavoritePlaceCell: View {
    let place: Location
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(place.location)
                .bodyP4Style(color: .black66)
                .foregroundStyle(Color.black66)
                .padding(.vertical, LayoutAdapter.shared.scale(value: 4))
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 8))
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
                    .foregroundStyle(Color(UIColor.blackAC))
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
        .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
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
    let colors = ScheduleColor.allColorsWithNames // [(Color, String)]
    
    var body: some View {
        Text("일정컬러")
        
        Divider()
        
        HStack {
            ForEach(colors, id: \.1) { colorPair in
                Circle()
                    .fill(colorPair.0)
                    .frame(width: LayoutAdapter.shared.scale(value: 18), height: LayoutAdapter.shared.scale(value: 18))
                    .onTapGesture {
                        color = colorPair.1
                    }
                    .padding(LayoutAdapter.shared.scale(value: 3))
                    .overlay(
                        Circle()
                            .stroke(Color(UIColor.blackD4), lineWidth: color == colorPair.1 ? 1 : 0)
                    )
            }
        }
        .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
    }
}

struct MemoView: View {
    @Binding var memo: String
    @Binding var isEditing: Bool
    let maxLength = 500
    
    var body: some View {
        HStack {
            Text("메모")
            
            Spacer()
            
            Text("\(memo.count)/\(maxLength)")
                .foregroundColor(memo.count == maxLength ? Color(UIColor.error) : Color(UIColor.black66))
                .bodyP4Style()
        }
        
        ScrollView {
            ZStack(alignment: .topLeading) {
                if memo.isEmpty {
                    HStack(spacing: 0) {
                        Text("메모를 작성해주세요.")
                            .foregroundStyle(memo.isEmpty ? Color(UIColor.blackAC) : .clear)
                        
                        Spacer()
                    }
                    .padding(LayoutAdapter.shared.scale(value: 10))
                }
                
                TextEditor(text: $memo)
                    .modifier(MaxLengthModifier(text: $memo, maxLength: maxLength))
                    .frame(height: LayoutAdapter.shared.scale(value: 110))
                    .padding(LayoutAdapter.shared.scale(value: 2))
                    .opacity(memo.isEmpty ? 0.1 : 1)
                    .onTapGesture {
                        isEditing = true
                    }
                    .onSubmit {
                        isEditing = false
                    }
            }
            .overlay(
                RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 8))
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

