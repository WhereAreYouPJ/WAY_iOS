//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CreateScheduleView: View {
    @StateObject var viewModel = CreateScheduleViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, content: {
                TextField("", text: $title, prompt: Text("메모를 작성해주세요.").foregroundColor(Color(.color118)))
                Divider()
                    .padding(.bottom, 16)
                
                DateAndTimeView()
                
                AddPlaceView()
                
                AddFriendsView()
                
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
                        dismiss()
                    }
                    .foregroundStyle(title.isEmpty ? Color.gray : Color.red)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("일정 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DateAndTimeView: View {
    @State private var isAllDay = true
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    private let dateFormatter: DateFormatter
    
    init() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        let startOfHour = calendar.date(from: components)!
        
        _startTime = State(initialValue: startOfHour)
        _endTime = State(initialValue: calendar.date(byAdding: .hour, value: 1, to: startOfHour)!)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
    }
    
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
    @State private var place = ""
    @State private var showSearchPlaceView = false
    
    var body: some View {
        Text("위치추가")
        Divider()
        
        HStack {
            Image("icon-place")
            if place.isEmpty {
                Text("위치 추가")
                    .foregroundStyle(Color(.color118))
                    .onTapGesture {
                        // 위치 추가 text를 누르면 SearchPlaceView로 이동
                        showSearchPlaceView = true
                    }
            } else {
                // TODO: 위치 추가 결과
            }
        }
        .navigationDestination(isPresented: $showSearchPlaceView) {
            SearchPlaceView()
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
                }
                
            }
            .padding(.bottom, 20)
        }
    }
}

struct AddFriendsView: View {
    @State private var friends = ["김민정", "임창균", "조승연", "김민지"]
    
    var body: some View {
        Text("친구추가")
        Divider()
        
        // TODO: friends 배열 비어있을 때 처리 필요(현재 코드에서 배열 비워두면 오류 발생)
        HStack {
            Image("icon-friends")
            if friends.isEmpty {
                Text("친구 추가")
                    .foregroundStyle(Color(.color118))
            } else {
                let count = friends.count
                ForEach(0..<2, id: \.self) { idx in
                    Text(friends[idx] + ", ")
                }
                Text(friends[2])
                
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
