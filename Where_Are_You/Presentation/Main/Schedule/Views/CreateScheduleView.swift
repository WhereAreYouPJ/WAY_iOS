//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

enum Route: Hashable {
    case searchPlace
    case searchFriends
}

struct CreateScheduleView: View {
    @StateObject var viewModel: CreateScheduleViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    
    init() {
        _viewModel = StateObject(wrappedValue: CreateScheduleViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, content: {
                TextField("", text: $viewModel.title, prompt: Text("메모를 작성해주세요.").foregroundColor(Color(.color118)))
                
                Divider()
                    .padding(.bottom, 16)
                
                DateAndTimeView(isAllDay: $viewModel.isAllDay, startTime: $viewModel.startTime, endTime: $viewModel.endTime)
                
                AddPlaceView(place: $viewModel.place, favPlaces: $viewModel.favPlaces, path: $path)
                
                AddFriendsView(selectedFriends: $viewModel.selectedFriends, path: $path)
                
                SetColorView(color: $viewModel.color)
                
                MemoView(memo: $viewModel.memo)
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
                    Button("추가") {
                        viewModel.postSchedule()
                        if viewModel.isSuccess {
                            dismiss()
                        } else {
                            // TODO: 일정 생성 예외 처리 필요, 실패 경우 동작 구현
                            dismiss()
                        }
                    }
                    .foregroundStyle(viewModel.title.isEmpty ? Color.gray : Color.red)
                    .disabled(viewModel.title.isEmpty)
                }
            }
            .navigationTitle("일정 추가")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .searchPlace:
                    SearchPlaceView(place: $viewModel.place, path: $path)
                case .searchFriends:
                    FriendsView(selectedFriends: $viewModel.selectedFriends)
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
    @Binding var place: Place?
    @Binding var favPlaces: [Place]
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("위치추가")
        Divider()
        
        HStack {
            Image("icon-place")
            if let place = place {
                Text(place.location)
                    .foregroundStyle(Color.primary)
            } else {
                Text("위치 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        path.append(Route.searchPlace)
                    }
            }
        }
        
        ScrollView(.horizontal) {
            HStack {
                //                let favPlaces: [Place] = [
                //                    .init(location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526),
                //                    .init(location: "여의도공원", streetName: "서울 영등포구 여의공원로 68", x: 37.5268, y: 126.9244),
                //                    .init(location: "올림픽체조경기장", streetName: "서울 종로구 세종대로 173", x: 37.5221, y: 127.1259),
                //                    .init(location: "재즈바", streetName: "서울 종로구 세종대로 174", x: 37.5665, y: 126.9780),
                //                    .init(location: "신도림", streetName: "서울 종로구 세종대로 175", x: 37.5088, y: 126.8912),
                //                    .init(location: "망원한강공원", streetName: "서울 종로구 세종대로 176", x: 37.5545, y: 126.8964),
                //                    .init(location: "부천시청", streetName: "서울 종로구 세종대로 177", x: 37.5037, y: 126.7661)
                //                ]
                ForEach(favPlaces) { favPlace in
                    FavoritePlaceCell(place: favPlace) {
                        place = favPlace
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}


struct FavoritePlaceCell: View {
    let place: Place
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(place.location)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.color240))
                )
                .foregroundColor(.primary)
        }
    }
}

struct AddFriendsView: View {
    @Binding var selectedFriends: [Friend]
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("친구추가")
        
        Divider()
        
        HStack {
            Image("icon-friends")
            if selectedFriends.isEmpty {
                Text("친구 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        path.append(Route.searchFriends)
                    }
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
            }
        }
        .padding(.bottom, 20)
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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    if memo.isEmpty {
                        Text("메모를 작성해주세요.")
                            .foregroundStyle(memo.isEmpty ? Color(.color118) : .clear)
                            .padding(10)
                    }
                    
                    TextEditor(text: $memo)
                        .modifier(MaxLengthModifier(text: $memo, maxLength: maxLength))
                        .frame(height: geometry.size.height)
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
}

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
    }
}

#Preview {
    CreateScheduleView()
}

