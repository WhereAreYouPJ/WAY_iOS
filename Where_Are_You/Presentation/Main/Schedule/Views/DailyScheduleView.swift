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
        ScrollView {
            VStack {
                HStack {
                    Text(viewModel.date.formatted(to: .monthDay))
                        .foregroundStyle(Color(.letterBrandColor))
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 22))))
                    
                    Spacer()
                }
                .padding(.bottom, LayoutAdapter.shared.scale(value: 10))
                
                scheduleListView()
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
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
        ForEach(viewModel.schedules, id: \.scheduleSeq) { schedule in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Circle()
                        .fill(viewModel.scheduleColor(for: schedule.color))
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
                                .foregroundStyle(Color(.color118))
                                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
                        })
                    .padding(.trailing, LayoutAdapter.shared.scale(value: 6))
                }
                
                Divider()
                    .padding(.vertical, 4)
            }
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
                    .foregroundStyle(Color(.black22))
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 16))))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
                
                groupTagView(for: schedule)
            }
            
            if let location = schedule.location?.location, !location.isEmpty {
                Text(location)
                    .foregroundStyle(Color(.color118))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 4))
            }
            
            if let scheduleDate = viewModel.getScheduleDate(schedule) {
                Text("\(scheduleDate)")
                    .foregroundStyle(Color(.color118))
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
                        .foregroundStyle(Color(.letterBrandColor))
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
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
