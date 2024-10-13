//
//  ScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State private var clickedCurrentMonthDates: Date?
    @State private var showMenu = false
    @State private var showCreateSchedule = false
    @State private var showDailySchedule = false
    
    // 추가: UIKit 버튼 액션을 위한 클로저
    var onNotificationTapped: (() -> Void)?
    var onAddTapped: (() -> Void)?
    
    init(
        onNotificationTapped: (() -> Void)? = nil,
        onAddTapped: (() -> Void)? = nil
    ) {
        self.onNotificationTapped = onNotificationTapped
        self.onAddTapped = onAddTapped
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    weekdayView
                    calendarGridView(in: geometry)
                }
                .padding(.horizontal, 10)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                yearMonthView
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        print("알림 페이지로 이동")
                    }) {
                        Image("icon-notification")
                            .frame(width: LayoutAdapter.shared.scale(value: 34), height: LayoutAdapter.shared.scale(value: 34))
                    }
                    .padding(0)
                    
                    Menu {
                        Button("일정 추가", action: {
                            print("일정 추가")
                            showCreateSchedule.toggle()
                        })
                    } label: {
                        Image("icon-plus")
                            .frame(width: LayoutAdapter.shared.scale(value: 34), height: LayoutAdapter.shared.scale(value: 34))
                    }
                    .padding(EdgeInsets(top: -4, leading: -8, bottom: -4, trailing: 0))
                }
            }
        }
        .onAppear(perform: {
            viewModel.getMonthlySchedule()
        })
        .sheet(isPresented: $showCreateSchedule, onDismiss: {
            viewModel.getMonthlySchedule()
        }) {
            CreateScheduleView()
        }
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
    }
    
    // MARK: 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                viewModel.changeMonth(by: -1)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            
            Text(viewModel.month, formatter: Self.calendarHeaderDateFormatter)
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 22))))
                .foregroundStyle(Color(.color17))
            
            Button(action: {
                viewModel.changeMonth(by: 1)
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            })
            
            Spacer()
        }
    }
    
    // MARK: 요일 표시
    private var weekdayView: some View {
        VStack {
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    Text(Self.weekdaySymbols[index].uppercased())
                        .foregroundColor(weekdayColor(for: index + 1))
                        .frame(maxWidth: .infinity)
                }
            }
            
            Divider()
        }
        .padding(.vertical, 5)
    }
    
    // MARK: 요일 색 지정
    private func weekdayColor(for index: Int) -> Color {
        switch index {
        case 1: return Color(.color255125)  // 일요일
        case 7: return Color(.color57125) // 토요일
        default: return Color(.color102)
        }
    }
    
    // MARK: 날짜 그리드 뷰
    private func calendarGridView(in geometry: GeometryProxy) -> some View {
        let daysInMonth: Int = numberOfDays(in: viewModel.month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: viewModel.month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        let availableHeight = geometry.size.height - LayoutAdapter.shared.scale(value: 80)
        let availableWidth = geometry.size.width
        let cellHeight = availableHeight / CGFloat(numberOfRows)
        let cellWidth = availableWidth / CGFloat(7) - 1
        
        let monthlySchedules = viewModel.monthlySchedules
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        currentMonthCell(for: index, cellHeight: cellHeight, monthlySchedules: monthlySchedules)
                    } else {
                        otherMonthCell(for: index, lastDayOfMonthBefore: lastDayOfMonthBefore, cellHeight: cellHeight, monthlySchedules: monthlySchedules)
                    }
                }
                .frame(width: cellWidth, height: cellHeight)
            }
        }
    }
    
    private func currentMonthCell(for index: Int, cellHeight: CGFloat, monthlySchedules: [Schedule]) -> some View {
        let date = getDate(for: index)
        let day = Calendar.current.component(.day, from: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        let clicked = clickedCurrentMonthDates == date
        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
        let daySchedules = monthlySchedules.filter { schedule in
            let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
            let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
            let cellDate = Calendar.current.startOfDay(for: date)
            return (scheduleStartDate...scheduleEndDate).contains(cellDate)
        }
        let processedSchedules = daySchedules.map { schedule in
            let isStart = Calendar.current.isDate(schedule.startTime, inSameDayAs: date)
            let isEnd = Calendar.current.isDate(schedule.endTime, inSameDayAs: date)
            return (schedule, isStart, isEnd)
        }
        
        print("Date: \(date), Schedules: \(daySchedules.map { $0.title })")
        
        return CellView(showDailySchedule: $showDailySchedule, day: day, clicked: clicked, isToday: isToday, isCurrentMonthDay: true, weekday: weekday, schedules: processedSchedules, clickedCurrentMonthDates: clickedCurrentMonthDates ?? Date.now)
            .onTapGesture {
                clickedCurrentMonthDates = date
                showDailySchedule = true
            }
            .frame(height: cellHeight)
    }
    
    private func otherMonthCell(for index: Int, lastDayOfMonthBefore: Int, cellHeight: CGFloat, monthlySchedules: [Schedule]) -> CellView {
        let calendar = Calendar.current
        let date = getDate(for: index)
        let daySchedules = monthlySchedules.filter { schedule in
            let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
            let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
            let cellDate = Calendar.current.startOfDay(for: date)
            return (scheduleStartDate...scheduleEndDate).contains(cellDate)
        }
        let processedSchedules = daySchedules.map { schedule in
            let isStart = Calendar.current.isDate(schedule.startTime, inSameDayAs: date)
            let isEnd = Calendar.current.isDate(schedule.endTime, inSameDayAs: date)
            return (schedule, isStart, isEnd)
        }
        if let prevMonthDate = calendar.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
        ) {
            let day = calendar.component(.day, from: prevMonthDate)
            let weekday = calendar.component(.weekday, from: prevMonthDate)
            
            return CellView(showDailySchedule: $showDailySchedule, day: day, isCurrentMonthDay: false, weekday: weekday, schedules: processedSchedules, clickedCurrentMonthDates: Date.now)
        } else {
            // 이전 달의 날짜를 계산할 수 없는 경우, 빈 CellView를 반환
            return CellView(showDailySchedule: $showDailySchedule, day: 0, isCurrentMonthDay: false, weekday: 1, schedules: processedSchedules, clickedCurrentMonthDates: Date.now)
        }
    }
    
}

// MARK: - CellView
private struct CellView: View { // TODO: 각 날짜에 맞게 일정 보여주기
    @Binding private var showDailySchedule: Bool
    private var clickedCurrentMonthDates: Date?
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var weekday: Int
    private var schedules: [(Schedule, Bool, Bool)] /// (일정, 오늘이 시작일인지, 오늘이 종료일인지)
    private var textColor: Color {
        if clicked {
            return .white
        } else if !isCurrentMonthDay {
            return Color(.color190)
        } else {
            switch weekday {
            case 1: return Color(.color25569)
            case 7: return Color(.color5769)
            default: return Color(.color17)
            }
        }
    }
    private var backgroundColor: Color {
        if clicked || isToday {
            return Color(.brandColor)
        } else {
            return .white
        }
    }
    
    fileprivate init(
        showDailySchedule: Binding<Bool>,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true,
        weekday: Int,
        schedules: [(Schedule, Bool, Bool)] = [],
        clickedCurrentMonthDates: Date?
    ) {
        self._showDailySchedule = showDailySchedule
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self.weekday = weekday
        self.schedules = schedules
        self.clickedCurrentMonthDates = clickedCurrentMonthDates
    }
    
    fileprivate var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if clicked {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 30, height: 30)
                } else if isToday {
                    Circle()
                        .stroke(backgroundColor, lineWidth: 1.5)
                        .frame(width: 30, height: 30)
                }
                
                Text(String(day))
                    .foregroundColor(textColor)
                    .frame(width: 30, height: 30)
            }
            .padding(.bottom, 2)
            
            VStack(spacing: 2) {
                ForEach(0..<min(3, schedules.count), id: \.self) { index in
                    scheduleBar(schedule: schedules[index].0, isStart: schedules[index].1, isEnd: schedules[index].2, isMoreThanFour: false)
                }
                if schedules.count > 3 {
                    scheduleBar(schedule: schedules[3].0, isStart: schedules[3].1, isEnd: schedules[3].2, isMoreThanFour: schedules.count > 4)
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showDailySchedule) {
            DailyScheduleView(date: clickedCurrentMonthDates ?? Date.now)
                .presentationDetents([.medium])
        }
    }
    
    private func scheduleBar(schedule: Schedule, isStart: Bool, isEnd: Bool, isMoreThanFour: Bool) -> some View {
        ZStack {
            let _ = print("The day is: \(weekday)")
            if isMoreThanFour { /// 네번째 일정부터는 "+"로 표시
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(.color231))
                    .padding(.horizontal, 2)
                
                Text("+")
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 9))))
                    .padding(.horizontal, 4)
            } else if isStart && isEnd { /// 단일 일정
                RoundedRectangle(cornerRadius: 2)
                    .fill(scheduleColor(for: schedule.color))
                    .padding(.horizontal, 2)
                
                Text(schedule.title)
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 9))))
                    .padding(.horizontal, 4)
            } else { /// 연속 일정
                if isStart {
                    if weekday == 7 { /// 첫날이고 토요일일 때
                        RoundedRectangle(cornerRadius: 2)
                            .fill(scheduleColor(for: schedule.color))
                            .padding(.horizontal, 2)
                    } else { /// 첫날이고 토요일이 아닐 때
                        UnevenRoundedRectangle(
                            topLeadingRadius: 2,
                            bottomLeadingRadius: 2
                        )
                        .fill(scheduleColor(for: schedule.color))
                        .padding(.leading, 2)
                    }
                    
                    Text(schedule.title)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 9))))
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if isEnd {
                    if weekday == 1 { /// 마지막날이고 일요일일 때
                        RoundedRectangle(cornerRadius: 2)
                            .fill(scheduleColor(for: schedule.color))
                            .padding(.horizontal, 2)
                        
                        Text(schedule.title)
                            .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 9))))
                            .padding(.horizontal, 4)
                    } else { /// 마지막날이고 일요일이 아닐 때
                        UnevenRoundedRectangle(
                            bottomTrailingRadius: 2, topTrailingRadius: 2
                        )
                        .fill(scheduleColor(for: schedule.color))
                        .padding(.trailing, 2)
                    }
                } else {
                    if weekday == 7 { /// 중간날이고 토요일일 때
                        UnevenRoundedRectangle(
                            bottomTrailingRadius: 2, topTrailingRadius: 2
                        )
                        .fill(scheduleColor(for: schedule.color))
                        .padding(.trailing, 2)
                    } else if weekday == 1 { /// 중간날이고 일요일일 때
                        UnevenRoundedRectangle(
                            topLeadingRadius: 2,
                            bottomLeadingRadius: 2
                        )
                        .fill(scheduleColor(for: schedule.color))
                        .padding(.leading, 2)
                        
                        Text(schedule.title)
                            .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 9))))
                            .padding(.horizontal, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Rectangle()
                            .fill(scheduleColor(for: schedule.color))
                            .padding(.trailing, 2)
                    }
                }
                
            }
        }
        .frame(height: LayoutAdapter.shared.scale(value: 14))
    }
    
    private func scheduleColor(for color: String) -> Color {
        switch color {
        case "red": return Color.colorRed
        case "yellow": return Color.colorYellow
        case "green": return Color.colorGreen
        case "blue": return Color.colorBlue
        case "violet": return Color.colorViolet
        case "pink": return Color.colorPink
        default: return Color.colorRed
        }
    }
}

// MARK: - ScheduleView Extensions
private extension ScheduleView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }()
    
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
    
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: viewModel.month),
                month: calendar.component(.month, from: viewModel.month),
                day: 1
            )
        ) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: viewModel.month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
}

// MARK: - Date Extension
extension Date {
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDayDate: String {
        return Date.calendarDayDateFormatter.string(from: self)
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
}

#Preview("CellView Variations") {
    VStack {
        HStack(spacing: 0) {
            CellView(showDailySchedule: .constant(false), day: 24, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 6, schedules: [
                (Schedule(scheduleSeq: 1, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, false),
                (Schedule(scheduleSeq: 2, title: "연속", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, false),
                (Schedule(scheduleSeq: 3, title: "금", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 4, title: "러닝", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ], clickedCurrentMonthDates: Date.now)
            .frame(width: 50, height: 120)
            
            CellView(showDailySchedule: .constant(false), day: 25, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 7, schedules: [
                (Schedule(scheduleSeq: 5, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, false),
                (Schedule(scheduleSeq: 6, title: "연속", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, true),
                (Schedule(scheduleSeq: 7, title: "토", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ], clickedCurrentMonthDates: Date.now)
            .frame(width: 50, height: 120)
        }
        HStack(spacing: 0) {
            CellView(showDailySchedule: .constant(false), day: 26, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 1, schedules: [
                (Schedule(scheduleSeq: 1, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, true),
                (Schedule(scheduleSeq: 2, title: "일", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 3, title: "한강", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 4, title: "러닝", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ], clickedCurrentMonthDates: Date.now)
            .frame(width: 50, height: 120)
            
            CellView(showDailySchedule: .constant(false), day: 27, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 2, schedules: [
                (Schedule(scheduleSeq: 6, title: "월", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 7, title: "드럼", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ], clickedCurrentMonthDates: Date.now)
            .frame(width: 50, height: 120)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
