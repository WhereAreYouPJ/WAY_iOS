//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CreateScheduleView: View {
        @StateObject var viewModel: CreateScheduleViewModel
        @Environment(\.dismiss) private var dismiss
        @State private var path = NavigationPath()
    
        @State private var schedule = Schedule()
        @State private var isAllDay = true
        @State private var startTime = Date()
        @State private var endTime = Date()
    
        private let dateFormatter: DateFormatter
    
        init() {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
            let startOfHour = calendar.date(from: components)!
    
            _viewModel = StateObject(wrappedValue: CreateScheduleViewModel())
            _startTime = State(initialValue: startOfHour)
            _endTime = State(initialValue: calendar.date(byAdding: .hour, value: 1, to: startOfHour)!)
    
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
        }
    
        var body: some View {
            NavigationStack(path: $path) {
                VStack(alignment: .leading, content: {
                    TextField("", text: $schedule.title, prompt: Text("메모를 작성해주세요.").foregroundColor(Color(.color118)))
                    Divider()
                        .padding(.bottom, 16)
    
                    DateAndTimeView(isAllDay: $isAllDay, startTime: $startTime, endTime: $endTime)
    
                    AddPlaceView(location: $schedule.location, streetName: $schedule.streetName, x: $schedule.x, y: $schedule.y, path: $path)
    
                    AddFriendsView(path: $path)
    
                    SetColorView()
    
                    MemoView()
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
                            viewModel.postSchedule(schedule: schedule)
                            dismiss()
                        }
                        .foregroundStyle(schedule.title.isEmpty ? Color.gray : Color.red)
                        .disabled(schedule.title.isEmpty)
                    }
                }
                .navigationTitle("일정 추가")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { route in
                    if route == "searchPlace" {
                        SearchPlaceView(location: $schedule.location, streetName: $schedule.streetName, x: $schedule.x, y: $schedule.y, path: $path)
                    } else if route == "friends" {
                        FriendsView()
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
        
        // TODO: 시각 hh(두 글자)로 포맷팅 필요, wheel 모달 창 띄우기
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
    @Binding var location: String
    @Binding var streetName: String
    @Binding var x: Double
    @Binding var y: Double
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("위치추가")
        Divider()
        
        HStack {
            Image("icon-place")
            if location.isEmpty {
                Text("위치 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        path.append("searchPlace")
                    }
            } else {
                Text(location)
                    .foregroundStyle(Color.primary)
            }
        }
        
        ScrollView(.horizontal) {
            HStack {
                let favPlaces = ["서울대", "여의도공원", "올림픽체조경기장", "재즈바", "신도림", "망원한강공원"]
                ForEach(favPlaces, id: \.self) { place in
                    Text(place)
                        .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                        .background(
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(Color(.color240))
                        )
                        .onTapGesture {
                            location = place
                            // Note: You might want to update streetName, x, and y here as well
                        }
                }
                
            }
            .padding(.bottom, 20)
        }
    }
}

struct AddFriendsView: View {
    @State private var friends: [String] = [] // dump: "김민정", "임창균", "조승연", "김민지"
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("친구추가")
        Divider()
        
        HStack {
            Image("icon-friends")
            if friends.isEmpty {
                Text("친구 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        path.append("friends")
                    }
            } else {
                let count = friends.count
                ForEach(0..<min(3, count), id: \.self) { idx in
                    if idx < count - 1 {
                        Text(friends[idx] + ", ")
                    } else {
                        Text(friends[idx])
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
    var body: some View {
        Text("일정컬러")
        Divider()
        
        HStack {
            Circle()
                .fill(.colorRed)
                .frame(width: 18, height: 18)
            
            Circle()
                .fill(.colorYellow)
                .frame(width: 18, height: 18)
            
            Circle()
                .fill(.colorGreen)
                .frame(width: 18, height: 18)
            
            Circle()
                .fill(.colorBlue)
                .frame(width: 18, height: 18)
            
            Circle()
                .fill(.colorViolet)
                .frame(width: 18, height: 18)
            
            Circle()
                .fill(.colorPink)
                .frame(width: 18, height: 18)
        }
        .padding(.bottom, 20)
    }
}

struct MemoView: View {
    @State private var memo = ""
    let maxLength = 10
    
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
                        .frame(height: geometry.size.height) // 상단 HStack의 높이를 고려하여 조정
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
