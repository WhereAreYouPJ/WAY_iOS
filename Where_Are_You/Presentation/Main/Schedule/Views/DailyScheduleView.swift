//
//  DailyScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 04.10.24.
//

import SwiftUI

struct DailyScheduleView: View {
    @StateObject private var viewModel: DailyScheduleViewModel
    
    @State private var scheduleForDetail: Schedule?
    @Binding var isPresented: Bool
    let onDeleteComplete: () -> Void  // 삭제 완료 콜백
    
    var dummySchedules = [
        Schedule(
            scheduleSeq: 1,
            title: "더미 일정",
            startTime: Date.now,
            endTime: Date.now,
            location: Location(sequence: 1, location: "신도림역", streetName: "서울 구로구 신도림동", x: 0, y: 0),
            color: "red",
            memo: ""
        ), Schedule(
            scheduleSeq: 2,
            title: "더미 일정 2",
            startTime: Date.now,
            endTime: Date.now,
            location: Location(sequence: 2, location: "신도림역", streetName: "서울 구로구 신도림동", x: 0, y: 0),
            color: "blue",
            memo: ""
        ), Schedule(
            scheduleSeq: 3,
            title: "더미 일정3",
            startTime: Date.now,
            endTime: Date.now,
            location: Location(sequence: 1, location: "신도림역", streetName: "서울 구로구 신도림동", x: 0, y: 0),
            color: "red",
            memo: ""
        ), Schedule(
            scheduleSeq: 4,
            title: "더미 일정 4",
            startTime: Date.now,
            endTime: Date.now,
            location: Location(sequence: 2, location: "신도림역", streetName: "서울 구로구 신도림동", x: 0, y: 0),
            color: "blue",
            memo: ""
        )
    ]
    
    init(
        date: Date,
        isPresented: Binding<Bool>,
        onDeleteComplete: @escaping () -> Void
    ) {
        let service = ScheduleService()
        let repository = ScheduleRepository(scheduleService: service)
        let getDailyScheduleUseCase = GetDailyScheduleUseCaseImpl(scheduleRepository: repository)
        let deleteScheduleUseCase = DeleteScheduleUseCaseImpl(scheduleRepository: repository)
        
        _viewModel = StateObject(wrappedValue: DailyScheduleViewModel(
            getDailyScheduleUseCase: getDailyScheduleUseCase,
            deleteScheduleUseCase: deleteScheduleUseCase,
            date: date
        ))
        
        _isPresented = isPresented
        self.onDeleteComplete = onDeleteComplete
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Color(.brandHighLight1)
                    .ignoresSafeArea()
                    .frame(width: .infinity, height: LayoutAdapter.shared.scale(value: 75))
                
                Text(viewModel.date.formatted(to: .monthDaySimple))
                    .titleH1Style(color: .brandDark)
                    .padding(.top, LayoutAdapter.shared.scale(value: 30))
                    .frame(width: .infinity, height: LayoutAdapter.shared.scale(value: 75))
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 24))
            }
            
            ScrollView {
                scheduleListView()
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 24))
            
            Spacer()
        }
        .customAlertModifier(
            isPresented: $viewModel.showingDeleteAlert,
            title: viewModel.selectedSchedule.map { viewModel.getDeleteAlertContent(for: $0).0 } ?? "일정 삭제",
            message: viewModel.selectedSchedule.map { viewModel.getDeleteAlertContent(for: $0).1 } ?? "",
            cancelTitle: "취소",
            actionTitle: "삭제"
        ) {
            viewModel.deleteSchedule { success in
                if success {
                    onDeleteComplete()  // 삭제 성공 시 콜백 호출
                }
            }
        }
        .onAppear {
            viewModel.getDailySchedule()
        }
    }
    
    private func scheduleListView() -> some View {
        ForEach(Array(dummySchedules.enumerated()), id: \.element.scheduleSeq) { index, schedule in
//        ForEach(Array(viewModel.schedules.enumerated()), id: \.element.scheduleSeq) { index, schedule in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Circle()
                        .fill(ScheduleColor.color(from: schedule.color))
                        .frame(width: LayoutAdapter.shared.scale(value: 10), height: LayoutAdapter.shared.scale(value: 10))
                        .padding(.trailing, LayoutAdapter.shared.scale(value: 10))
                    
                    scheduleDetialsView(for: schedule)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            viewModel.showDeleteAlert(for: schedule)
                        },
                        label: {
                            Text("삭제")
                                .bodyP4Style(color: .black66)
                        })
                    .padding(.trailing, LayoutAdapter.shared.scale(value: 6))
                }
                
                Divider()
                    .padding(.vertical, LayoutAdapter.shared.scale(value: 12))
            }
            .padding(.top, index == 0 ? LayoutAdapter.shared.scale(value: 16) : 0) // 첫 번째 항목일 때만 상단 패딩
            .contentShape(Rectangle())
            .onTapGesture {
                scheduleForDetail = schedule
            }
        }
        .sheet(item: $scheduleForDetail) { schedule in
            NavigationStack {
                ScheduleDetailView(schedule: schedule)
                    .onDisappear {
                        viewModel.getDailySchedule()
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func scheduleDetialsView(for schedule: Schedule) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(schedule.title)
                    .bodyP3Style(color: .black22)
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
                
                groupTagView(for: schedule)
            }
            
            if let location = schedule.location?.location, !location.isEmpty {
                Text(location)
                    .bodyP4Style(color: .black66)
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
            }
            
            if let scheduleDate = viewModel.getScheduleDate(schedule) {
                Text("\(scheduleDate)")
                    .bodyP4Style(color: .black66)
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
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
                        .bodyP4Style(color: .brandDark)
                }
                .padding(.bottom, LayoutAdapter.shared.scale(value: 2))
            }
        }
    }
}

#Preview {
    DailyScheduleView(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!,
            isPresented: .constant(true),
            onDeleteComplete: {
                print("일정 삭제 완료")
            }
        )
    .presentationDetents([.medium])
    .presentationBackground(.clear)
}
