//
//  ScheduleView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct ScheduleView: View {
    // TODO: 가끔 일정 조회시 누락되는 일정 발생. 원인 추측: 특히 다중날짜 일정이 있을 경우 or 월이 다른 일정
    @StateObject var viewModel: ScheduleViewModel
    @StateObject private var notificationBadgeViewModel = NotificationBadgeViewModel.shared
    
    @State private var showNotification = false
    @State private var showOptionMenu = false
    @State private var showCreateSchedule = false
    
//    @State private var selectedDate: Date?
    @State private var showDailySchedule = false
    
//    @State private var selectedPickerDate = Date()
    @State private var showDatePicker = false
    
    init() {
        let repository = ScheduleRepository(scheduleService: ScheduleService())
        let getMonthlyScheduleUseCase = GetMonthlyScheduleUseCaseImpl(scheduleRepository: repository)
        
        _viewModel = StateObject(wrappedValue: ScheduleViewModel(
            getMonthlyScheduleUseCase: getMonthlyScheduleUseCase
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        yearMonthView
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                showNotification = true
                            }, label: {
                                Image(notificationBadgeViewModel.hasUnreadNotifications ? "icon-notification-badge" : "icon-notification")
                                    .frame(width: LayoutAdapter.shared.scale(value: 34), height: LayoutAdapter.shared.scale(value: 34))
                            })
                            .padding(0)
                            
                            Button(action: {
                                showOptionMenu.toggle()
                            }, label: {
                                Image("icon-plus")
                                    .frame(width: LayoutAdapter.shared.scale(value: 34), height: LayoutAdapter.shared.scale(value: 34))
                            })
                        }
                    }
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 6))
                    .padding(.top, LayoutAdapter.shared.scale(value: -2))
                    
                    weekdayView
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    calendarGridView(in: geometry)
                }
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 10))
                
                if showOptionMenu {
                    Color.clear // 배경 터치시 메뉴 닫기
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showOptionMenu = false
                        }
                    
                    OptionButtonView(topPadding: LayoutAdapter.shared.scale(value: 36), content: {
                        OptionButton(
                            title: "일정 추가",
                            position: .single
                        ) {
                            showOptionMenu = false
                            showCreateSchedule.toggle()
                        }
                    })
                }
            }
        }
        .fullScreenCover(isPresented: $showNotification, content: {
            NotificationView()
        })
        .sheet(isPresented: $showCreateSchedule, onDismiss: {
            viewModel.getMonthlySchedule()
        }, content: {
//            CreateScheduleView()
            CreateScheduleView(initialDate: viewModel.getDateForNewSchedule())
        }
        )
        .sheet(isPresented: $showDailySchedule) {
            if let date = viewModel.selectedDate {
                DailyScheduleView(
                    date: date,
                    isPresented: $showDailySchedule,
                    onDeleteComplete: {
                        viewModel.getMonthlySchedule()
                    }
                )
                .presentationDetents([.medium])
            }
        }
        .onAppear(perform: {
            viewModel.getMonthlySchedule()
            notificationBadgeViewModel.checkForNewNotifications()
            
//            selectedPickerDate = Date() // 피커 날짜 오늘로 초기화
        })
        .datepickerOverlay(isPresented: $showDatePicker) {
//            FullDatePickerView(
//                selectedDate: $selectedPickerDate,
//                isPresented: $showDatePicker,
//                onCancel: {
//                    // 취소 시 동작 (옵션)
//                },
//                onConfirm: { date in
//                    handleDateSelection(date)
//                }
//            )
            FullDatePickerView(
                selectedDate: Binding(
                    get: { viewModel.selectedDate ?? Date() }, // 🔄 selectedPickerDate 대신 viewModel.selectedDate 사용
                    set: { viewModel.selectedDate = $0 } // 🔄 직접 ViewModel의 selectDate 호출
                ),
                isPresented: $showDatePicker,
                onCancel: {
                    // 취소 시 동작 (옵션)
                },
                onConfirm: { date in
                    handleDateSelection(date)
                }
            )
        }
    }
    
    // MARK: 연월 표시
    private var yearMonthView: some View {
        HStack {
            Button(action: {
                // 피커가 표시될 때 현재 선택된 월로 피커 날짜 초기화
//                selectedPickerDate = viewModel.month
                showDatePicker = true
            }, label: {
                Text(viewModel.month.formatted(to: .yearMonth))
                    .titleH1Style(color: .black22)
                
                Image("control")
            })
        }
    }
    
    private func handleDateSelection(_ date: Date) {
        let calendar = Calendar.current // 현재 표시 중인 월과 선택한 날짜의 월 비교
        
        let currentMonth = calendar.component(.month, from: viewModel.month)
        let selectedMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: viewModel.month)
        let selectedYear = calendar.component(.year, from: date)
        
//        selectedPickerDate = date // 선택한 날짜로 selectedDate 업데이트
        viewModel.selectedDate = date
        print("📆 선택된 날짜: \(date)")
        
        if currentMonth != selectedMonth || currentYear != selectedYear { // 월이 다른 경우 월 변경 (월 차이 계산)
            let yearDiff = selectedYear - currentYear
            let monthDiff = selectedMonth - currentMonth
            let totalMonthDiff = yearDiff * 12 + monthDiff
            
            viewModel.changeMonth(by: totalMonthDiff)
        }
        
        viewModel.getMonthlySchedule()
    }
    
    // MARK: 요일 표시
    private var weekdayView: some View {
        VStack {
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    Text(Self.weekdaySymbols[index].uppercased())
                        .bodyP4Style(color: weekdayColor(for: index + 1))
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
        default: return Color(.black22)
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
        let calendar = Calendar.koreaCalendar
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        let clicked = viewModel.selectedDate == date
        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
//        let isSelectedInPicker = calendar.isDate(date, inSameDayAs: selectedPickerDate)
//        let isSelectedInPicker = date.isSameYMD(as: selectedPickerDate)
        let isSelectedInPicker = date.isSameYMD(as: date)
        
        let daySchedules = monthlySchedules.filter { schedule in
            let scheduleStartDate = calendar.startOfDay(for: schedule.startTime)
            let scheduleEndDate = calendar.startOfDay(for: schedule.endTime)
            let cellDate = calendar.startOfDay(for: date)
            return (scheduleStartDate...scheduleEndDate).contains(cellDate)
        }
        let processedSchedules = daySchedules.map { schedule in
            let isStart = calendar.isDate(schedule.startTime, inSameDayAs: date)
            let isEnd = calendar.isDate(schedule.endTime, inSameDayAs: date)
            return (schedule, isStart, isEnd)
        }
        
        return CellView(
            day: day,
            clicked: clicked,
            isToday: isToday,
            isSelectedInPicker: isSelectedInPicker,
            isCurrentMonthDay: true,
            weekday: weekday,
            schedules: processedSchedules
        )
        .onTapGesture {
            viewModel.selectedDate = date
            showDailySchedule = true
        }
        .frame(height: cellHeight)
    }
    
    private func otherMonthCell(for index: Int, lastDayOfMonthBefore: Int, cellHeight: CGFloat, monthlySchedules: [Schedule]) -> CellView {
        let calendar = Calendar.koreaCalendar
        let date = getDate(for: index)
        
//        let isSelectedInPicker = calendar.isDate(date, inSameDayAs: selectedPickerDate)
//        let isSelectedInPicker = date.isSameYMD(as: selectedPickerDate)
        let isSelectedInPicker = date.isSameYMD(as: date)
        
        let daySchedules = monthlySchedules.filter { schedule in
            let scheduleStartDate = calendar.startOfDay(for: schedule.startTime)
            let scheduleEndDate = calendar.startOfDay(for: schedule.endTime)
            let cellDate = calendar.startOfDay(for: date)
            
            return (scheduleStartDate...scheduleEndDate).contains(cellDate)
        }
        let processedSchedules = daySchedules.map { schedule in
            let isStart = calendar.isDate(schedule.startTime, inSameDayAs: date)
            let isEnd = calendar.isDate(schedule.endTime, inSameDayAs: date)
            return (schedule, isStart, isEnd)
        }
        
        if let prevMonthDate = calendar.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
        ) {
            let day = calendar.component(.day, from: prevMonthDate)
            let weekday = calendar.component(.weekday, from: prevMonthDate)
            
            return CellView(
                day: day,
                isSelectedInPicker: isSelectedInPicker,
                isCurrentMonthDay: false,
                weekday: weekday,
                schedules: processedSchedules
            )
        } else {
            // 이전 달의 날짜를 계산할 수 없는 경우, 빈 CellView를 반환
            return CellView(
                day: 0,
                isSelectedInPicker: isSelectedInPicker,
                isCurrentMonthDay: false,
                weekday: 1,
                schedules: processedSchedules)
        }
    }
    
}

// MARK: - CellView
private struct CellView: View {
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isSelectedInPicker: Bool // DatePicker를 통해 선택된 날짜인지
    private var isCurrentMonthDay: Bool
    private var weekday: Int
    private var schedules: [(Schedule, Bool, Bool)] // (일정, 오늘이 시작일인지, 오늘이 종료일인지)
    
    private var textColor: Color {
        if clicked {
            return .white
        } else if !isCurrentMonthDay {
            return .blackAC
        } else {
            switch weekday {
            case 1: return Color(.color25569)
            case 7: return Color(.color5769)
            default: return .black22
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
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isSelectedInPicker: Bool = false,
        isCurrentMonthDay: Bool = true,
        weekday: Int,
        schedules: [(Schedule, Bool, Bool)] = [] // (일정, 오늘 시작하는 날인지, 오늘 끝나는 날인지)
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isSelectedInPicker = isSelectedInPicker
        self.isCurrentMonthDay = isCurrentMonthDay
        self.weekday = weekday
        self.schedules = schedules
    }
    
    fileprivate var body: some View {
        VStack(alignment: .center) {
            ZStack {
                let _ = print("📆 isSelectedInPicker in CellView: \(self.isSelectedInPicker)")
                if clicked { // 터치 시 채워진 동그라미 표시
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 30, height: 30)
                } else if isToday || isSelectedInPicker { // 오늘 or 피커로 선택한 날짜일 시 빈 동그라미 표시
                    Circle()
                        .stroke(backgroundColor, lineWidth: 1.5)
                        .frame(width: 30, height: 30)
                }
                
                Text(String(day))
                    .bodyP4Style(color: textColor)
                    .frame(width: 30, height: 30)
            }
            .padding(.bottom, 2)
            
            // 1. 일정 정렬. 오랜 기간 일정일 수록 앞에 오도록
            let sortedSchedules = schedules.sorted { (a, b) in
                // 첫 번째 기준: 연속 일정이 단일 일정보다 우선
                let aIsMultiDay = !(a.1 && a.2)
                let bIsMultiDay = !(b.1 && b.2)
                
                if aIsMultiDay != bIsMultiDay {
                    return aIsMultiDay
                }
                
                // 둘 다 연속 일정인 경우, 일정 기간으로 정렬
                if aIsMultiDay && bIsMultiDay {
                    let aDuration = Calendar.current.dateComponents([.day],
                                                                    from: a.0.startTime,
                                                                    to: a.0.endTime).day ?? 0
                    let bDuration = Calendar.current.dateComponents([.day],
                                                                    from: b.0.startTime,
                                                                    to: b.0.endTime).day ?? 0
                    return aDuration > bDuration
                }
                
                return false
            }
            
            // 2. 정렬된 일정 목록을 기반으로 스케줄바 표시
            VStack(spacing: 2) {
                // 최대 3개까지 일정 표시
                ForEach(0..<min(3, sortedSchedules.count), id: \.self) { index in
                    scheduleBar(
                        schedule: sortedSchedules[index].0,
                        isStart: sortedSchedules[index].1,
                        isEnd: sortedSchedules[index].2,
                        isMoreThanFour: false
                    )
                }
                
                // 3개 초과 일정이 있는 경우 "+" 표시
                if sortedSchedules.count > 3 {
                    scheduleBar(
                        schedule: sortedSchedules[3].0,
                        isStart: sortedSchedules[3].1,
                        isEnd: sortedSchedules[3].2,
                        isMoreThanFour: true
                    )
                }
            }
            
            Spacer()
        }
    }
    
    private func scheduleBar(schedule: Schedule, isStart: Bool, isEnd: Bool, isMoreThanFour: Bool) -> some View {
        let scheduleColor = ScheduleColor.color(from: schedule.color)
        
        return ZStack {
            if isMoreThanFour { /// 네번째 일정부터는 "+"로 표시
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.color231))
                    .padding(.horizontal, 2)
                
                Text("+")
                    .button9Style(color: .black22)
                    .padding(.horizontal, 4)
            } else if isStart && isEnd { /// 단일 일정
                RoundedRectangle(cornerRadius: 4)
                    .fill(scheduleColor)
                    .padding(.horizontal, 2)
                
                Text(schedule.title)
                    .button9Style(color: .black22)
                    .padding(.horizontal, 4)
            } else { /// 연속 일정
                if isStart {
                    if weekday == 7 { /// 첫날이고 토요일일 때
                        RoundedRectangle(cornerRadius: 4)
                            .fill(scheduleColor)
                            .padding(.horizontal, 2)
                    } else { /// 첫날이고 토요일이 아닐 때
                        UnevenRoundedRectangle(
                            topLeadingRadius: 4,
                            bottomLeadingRadius: 4
                        )
                        .fill(scheduleColor)
                        .padding(.leading, 2)
                    }
                    
                    Text(schedule.title)
                        .button9Style(color: .black22)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if isEnd {
                    if weekday == 1 { /// 마지막날이고 일요일일 때
                        RoundedRectangle(cornerRadius: 4)
                            .fill(scheduleColor)
                            .padding(.horizontal, 2)
                        
                        Text(schedule.title)
                            .button9Style(color: .black22)
                            .padding(.horizontal, 4)
                    } else { /// 마지막날이고 일요일이 아닐 때
                        UnevenRoundedRectangle(
                            bottomTrailingRadius: 4, topTrailingRadius: 4
                        )
                        .fill(scheduleColor)
                        .padding(.trailing, 2)
                    }
                } else {
                    if weekday == 7 { /// 중간날이고 토요일일 때
                        UnevenRoundedRectangle(
                            bottomTrailingRadius: 4, topTrailingRadius: 4
                        )
                        .fill(scheduleColor)
                        .padding(.trailing, 2)
                    } else if weekday == 1 { /// 중간날이고 일요일일 때
                        UnevenRoundedRectangle(
                            topLeadingRadius: 4,
                            bottomLeadingRadius: 4
                        )
                        .fill(scheduleColor)
                        .padding(.leading, 2)
                        
                        Text(schedule.title)
                            .button9Style(color: .black22)
                            .padding(.horizontal, 4)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Rectangle()
                            .fill(scheduleColor)
                            .padding(.trailing, 2)
                    }
                }
                
            }
        }
        .frame(height: LayoutAdapter.shared.scale(value: 14))
    }
}

// MARK: - ScheduleView Extensions
private extension ScheduleView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
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

// TabBar에 접근하기 위한 헬퍼 구조체
struct TabBarAccessor: UIViewRepresentable {
    let callback: (UITabBar) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let tabBar = self.findTabBar(view: view) {
                self.callback(tabBar)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    private func findTabBar(view: UIView) -> UITabBar? {
        if let tabBar = view.superview?.superview as? UITabBar {
            return tabBar
        }
        
        for subview in view.subviews {
            if let tabBar = findTabBar(view: subview) {
                return tabBar
            }
        }
        return nil
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
}

#Preview("CellView Variations") {
    VStack {
        HStack(spacing: 0) {
            CellView(day: 24, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 6, schedules: [
                (Schedule(scheduleSeq: 1, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, false),
                (Schedule(scheduleSeq: 2, title: "연속", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, false),
                (Schedule(scheduleSeq: 3, title: "금", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 4, title: "러닝", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ])
            .frame(width: 50, height: 120)
            
            CellView(day: 25, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 7, schedules: [
                (Schedule(scheduleSeq: 5, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, false),
                (Schedule(scheduleSeq: 6, title: "연속", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, true),
                (Schedule(scheduleSeq: 7, title: "토", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ])
            .frame(width: 50, height: 120)
        }
        HStack(spacing: 0) {
            CellView(day: 26, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 1, schedules: [
                (Schedule(scheduleSeq: 1, title: "연속3일정", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), false, true),
                (Schedule(scheduleSeq: 2, title: "일", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 3, title: "한강", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 4, title: "러닝", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ])
            .frame(width: 50, height: 120)
            
            CellView(day: 27, clicked: false, isToday: false, isCurrentMonthDay: true, weekday: 2, schedules: [
                (Schedule(scheduleSeq: 6, title: "월", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true),
                (Schedule(scheduleSeq: 7, title: "드럼", startTime: Date.now, endTime: Date.now, isAllday: true, location: nil, color: "red", memo: "", invitedMember: []), true, true)
            ])
            .frame(width: 50, height: 120)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
