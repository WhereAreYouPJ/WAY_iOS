//
//  DailyScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 04.10.24.
//

import SwiftUI

struct DailyScheduleView: View {
    @StateObject private var viewModel: DailyScheduleViewModel
    @State private var showingScheduleDetail = false
    @State private var showingDeleteAlert = false
    @State private var selectedSchedule: Schedule?
    @Binding var isPresented: Bool
    var onDeleteSchedule: (Schedule, String, String) -> Void
    private let formatter = DateFormatter()
    
    // MARK: dummy data
    let schedules: [Schedule] = [
        Schedule(
            scheduleSeq: 1,
            title: "3일 연속 일정",
            startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            isAllday: true,
            location: Location(sequence: 1, location: "망원한강공원", streetName: "", x: 0, y: 0),
            color: "red",
            memo: "",
            invitedMember: [Friend(memberSeq: 1, profileImage: "", name: "")]
        ),
        Schedule(
            scheduleSeq: 2,
            title: "오늘 하루 종일",
            startTime: Calendar.current.startOfDay(for: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
            isAllday: true,
            location: nil,
            color: "blue",
            memo: "",
            invitedMember: []
        ),
        Schedule(
            scheduleSeq: 3,
            title: "오후 쇼핑",
            startTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!,
            isAllday: false,
            location: Location(sequence: 1, location: "성수역", streetName: "", x: 0, y: 0),
            color: "yellow",
            memo: "",
            invitedMember: []
        ),
        Schedule(
            scheduleSeq: 4,
            title: "새벽 러닝",
            startTime: Calendar.current.date(bySettingHour: 5, minute: 30, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!,
            isAllday: false,
            location: nil,
            color: "violet",
            memo: "",
            invitedMember: []
        ),
        Schedule(
            scheduleSeq: 5,
            title: "자정 넘어가는 영화",
            startTime: Calendar.current.date(bySettingHour: 22, minute: 10, second: 0, of: Date())!,
            endTime: Calendar.current.date(byAdding: .hour, value: 3, to: Calendar.current.date(bySettingHour: 22, minute: 10, second: 0, of: Date())!)!,
            isAllday: false,
            location: Location(sequence: 2, location: "강남역 CGV", streetName: "", x: 0, y: 0),
            color: "green",
            memo: "",
            invitedMember: []
        ),
        Schedule(
            scheduleSeq: 6,
            title: "점심 약속",
            startTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
            isAllday: false,
            location: Location(sequence: 3, location: "강남역 레스토랑", streetName: "", x: 0, y: 0),
            color: "pink",
            memo: "",
            invitedMember: [Friend(memberSeq: 2, profileImage: "", name: "김철수")]
        )
    ]
    
    init(date: Date, isPresented: Binding<Bool>, onDeleteSchedule: @escaping (Schedule, String, String) -> Void) {
        let service = ScheduleService()
        _viewModel = StateObject(wrappedValue: DailyScheduleViewModel(date: date, service: service))
        formatter.dateFormat = "MM월 dd일"
        self.onDeleteSchedule = onDeleteSchedule
        self._isPresented = isPresented
    }
    
    var body: some View {
        ScrollView() {
            VStack {
                HStack {
                    Text(formatter.string(from: viewModel.date))
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
        .alert(isPresented: $showingDeleteAlert) {
            if let schedule = selectedSchedule {
                let (title, message) = setAlertContent(for: schedule)
                return Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: .destructive(Text("삭제")) {
                        viewModel.deleteSchedule(schedule) { isEmpty in
                            if isEmpty {
                                isPresented = false // 일정이 모두 삭제되면 모달 닫기
                            }
                        }
                        //                        onDeleteSchedule(schedule, title, message)
                        //                        isPresented = false
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            } else {
                return Alert(title: Text("Error"))
            }
        }
        .onAppear {
            viewModel.getDailySchedule()
        }
    }
    
    private func scheduleListView() -> some View {
        // dummy test
//        ForEach(schedules, id: \.scheduleSeq) { schedule in
        ForEach(viewModel.schedules, id: \.scheduleSeq) { schedule in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Circle()
                        .fill(viewModel.scheduleColor(for: schedule.color))
                        .frame(width: LayoutAdapter.shared.scale(value: 10), height: LayoutAdapter.shared.scale(value: 10))
                        .padding(.trailing, LayoutAdapter.shared.scale(value: 10))
                    
                    scheduleDetialsView(for: schedule)
                    
                    Spacer()
                    
                    Button(action: {
                        //                        let (title, message) = setAlertContent(for: schedule)
                        //                        onDeleteSchedule(schedule, title, message)
                        selectedSchedule = schedule
                        showingDeleteAlert = true
                        //                        isPresented = false
                    }) {
                        Text("삭제")
                            .foregroundStyle(Color(.color118))
                            .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
                    }
                    .padding(.trailing, LayoutAdapter.shared.scale(value: 6))
                }
                
                Divider()
                    .padding(.vertical, 4)
            }
            .contentShape(Rectangle())  // 전체 영역을 탭 가능하게 만듦
            .onTapGesture {
                selectedSchedule = schedule
                showingScheduleDetail = true
            }
        }
        .sheet(isPresented: $showingScheduleDetail) {
            if let schedule = selectedSchedule {
                NavigationStack {
                    ScheduleDetailView(schedule: schedule)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
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
    
    private func setAlertContent(for schedule: Schedule) -> (String, String) {
        if schedule.invitedMember?.count ?? 0 > 0 {
            return ("그룹 일정 삭제", "그룹 일정을 삭제합니다.\n모든 참여자의 일정에서 삭제되며, 연관된 피드도 함께 삭제됩니다.")
        } else {
            return ("일정 삭제", "일정을 삭제합니다.\n연관된 피드가 있을 경우 함께 삭제됩니다.")
        }
    }
    
}

#Preview {
    DailyScheduleView(date: Date.now, isPresented: .constant(true)) { schedule, title, message in
        print("Delete requested for schedule: \(schedule.title)")
        print("Alert Title: \(title)")
        print("Alert Message: \(message)")
    }
    .presentationDetents([.medium])
    .presentationBackground(.clear)
}
