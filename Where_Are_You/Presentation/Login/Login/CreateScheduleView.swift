//
//  CreateScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CreateScheduleView: View {
    @State private var scheduleName = ""
    @State private var duringAllday = true
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var place = "위치 추가"
    
    var body: some View {
        VStack(alignment: .leading, content: {
            TextField("일정명을 입력해주세요.", text: $scheduleName)
            
            Toggle(isOn: $duringAllday, label: {
                Text("하루 종일")
            })
            
            Text("위치 확인하기 기능이 제공되지 않습니다.")
            
            DatePicker("시작", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
            
            DatePicker("종료", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
            
            Text("위치 추가")
            
            HStack {
                Image("icon-place")
                Text(place)
            }
            
        
            HStack {
                Text("서울대")
                    .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .fill(Color(.color240))
                    )
                Text("서울대")
                    .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .fill(Color(.color240))
                    )
                Text("서울대")
                    .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .fill(Color(.color240))
                    )
            }
            
            
        })
        .padding(15)
    }
}

#Preview {
    CreateScheduleView()
}
