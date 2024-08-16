//
//  CalendarView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct ScheduleView: View {
    @State private var showModal = false
    
    var body: some View {
        VStack {
            Button {
                self.showModal = true
            } label: {
                Text("일정 추가")
            }
            .sheet(isPresented: self.$showModal, content: {
                CreateScheduleView()
                    .interactiveDismissDisabled()
            })
        }
    }
}

#Preview {
    ScheduleView()
}
