//
//  DailyScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 04.10.24.
//

import SwiftUI

struct DailyScheduleView: View {
    @StateObject private var viewModel: DailyScheduleViewModel
    private let formatter = DateFormatter()
    
    init(date: Date) {
        _viewModel = StateObject(wrappedValue: DailyScheduleViewModel(date: date))
        formatter.dateFormat = "MM월 dd일"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(formatter.string(from: viewModel.date))
                    .foregroundStyle(Color(.letterBrandColor))
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 22))))
                
                Spacer()
            }
            
            scheduleListView()
        }
        .padding(LayoutAdapter.shared.scale(value: 16))
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
    }
    
    private func scheduleListView() -> some View {
        ForEach(viewModel.schedules, id: \.scheduleSeq) { schedule in
            VStack {
                HStack(spacing: 0) {
                    Circle()
                        .fill(viewModel.scheduleColor(for: schedule.color))
                        .frame(width: LayoutAdapter.shared.scale(value: 10), height: LayoutAdapter.shared.scale(value: 10))
                        .padding(.trailing, LayoutAdapter.shared.scale(value: 10))
                    
                    scheduleDetialsView(for: schedule)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.deleteSchedule(schedule)
                    }) {
                        Text("삭제")
                            .foregroundStyle(Color(.color118))
                            .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
                    }
                    .padding(.trailing, LayoutAdapter.shared.scale(value: 6))
                }
                
                Divider()
            }
        }
    }
    
    private func scheduleDetialsView(for schedule: Schedule) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(schedule.title)
                    .foregroundStyle(Color(.color34))
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 16))))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
                
                groupTagView(for: schedule)
            }
            
            if let location = schedule.location?.location {
                Text(location)
                    .foregroundStyle(Color(.color118))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
            }
            
            Group {
                if !(schedule.isAllday ?? false) {
                    Text("\(viewModel.formatDate(schedule.startTime)) - \(viewModel.formatDate(schedule.endTime))")
                        .foregroundStyle(Color(.color118))
                        .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
                }
            }
        }
    }
    
    private func groupTagView(for schedule: Schedule) -> some View {
        Group {
            if schedule.invitedMember?.count ?? 0 > 0 {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.white)
                        .stroke(Color(.brandColor), lineWidth: 1)
                        .frame(width: LayoutAdapter.shared.scale(value: 39), height: LayoutAdapter.shared.scale(value: 24))
                    Text("그룹")
                        .foregroundStyle(Color(.letterBrandColor))
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
                }
                .padding(.bottom, LayoutAdapter.shared.scale(value: 2))
            }
        }
    }
}

#Preview {
    DailyScheduleView(date: Date.now)
}


