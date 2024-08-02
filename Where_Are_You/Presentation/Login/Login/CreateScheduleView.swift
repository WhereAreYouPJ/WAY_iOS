//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CreateScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var scheduleName = ""
    @State private var duringAllday = true
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var place = ""
    @State private var friends = ["김민정", "임창균", "박지성", "김민지"]
    @State private var memo = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, content: {
                TextField("일정명을 입력해주세요.", text: $scheduleName)
                Divider()
                    .padding(.bottom, 16)
                
                Toggle(isOn: $duringAllday, label: {
                    Text("하루 종일")
                })
                
                HStack {
                    Image("icon-information")
                    Text("위치 확인하기 기능이 제공되지 않습니다.")
                    //                    .font(.system(.footnote))
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 12)))
                        .foregroundStyle(.red)
                }
                Divider()
                
                DatePicker("시작", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                Divider()
                
                DatePicker("종료", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                Divider()
                    .padding(.bottom, 20)
                
                Text("위치 추가")
                Divider()
                
                HStack {
                    Image("icon-place")
                    if place.isEmpty {
                        Text("위치 추가")
                            .foregroundStyle(Color(.color118))
                    } else {
                        
                    }
                }
                
                HStack {
                    Text("서울대")
                        .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                        .background(
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(Color(.color240))
                        )
                }
                .padding(.bottom, 20)
                
                Text("친구추가")
                Divider()
                
                HStack {
                    Image("icon-friends")
                    if friends.isEmpty {
                        Text("친구 추가")
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
                
                Text("메모")
                Divider()
                
                TextEditor(text: $memo)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.color212))
                    )
            })
            .padding(15)
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("확인") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("일정 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateScheduleView()
}
