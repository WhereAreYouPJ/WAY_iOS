//
//  CalendarView.swift
//  Where_Are_You
//
//  Created by juhee on 01.08.24.
//

import SwiftUI

struct CalendarView: View {
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    @State private var showMenu = false
    @State private var showCreateSchedule = false
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerView
                weekdayView
                calendarGridView(in: geometry)
            }
            .padding(.horizontal, 10)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    // MARK: 헤더
    private var headerView: some View {
        VStack {
            HStack {
                yearMonthView
                
                Spacer()
                
                Button(action: {}, label: {
                    Image("icon-notification")
                })
                
                Menu {
                    Button(action: {self.showCreateSchedule = true}, label: {
                        Text("일정 추가")
                    })
                    .foregroundStyle(.white)
                    .background(Color(.color81))
                } label: {
                    Image("icon-plus")
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: self.$showCreateSchedule, content: {
            CreateScheduleView()
                .interactiveDismissDisabled()
        })
    }
    
    // MARK: 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
            )
            
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.title)
            
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.black)
                }
            )
        }
    }
    
    // MARK: 요일 표시
    private var weekdayView: some View {
        VStack {
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    Text(Self.weekdaySymbols[index].uppercased())
                        .foregroundColor(weekdayColor(for: index))
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
        case 0: return .red  // 일요일
        case 6: return .blue // 토요일
        default: return .black
        }
    }
    
    // MARK: 날짜 그리드 뷰
    private func calendarGridView(in geometry: GeometryProxy) -> some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)

        let availableHeight = geometry.size.height - 100
        let cellHeight = availableHeight / CGFloat(numberOfRows)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let weekday = Calendar.current.component(.weekday, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate

                        CellView(day: day, clicked: clicked, isToday: isToday, isCurrentMonthDay: true, weekday: weekday)
                            .onTapGesture {
                                clickedCurrentMonthDates = date
                            }
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        let weekday = Calendar.current.component(.weekday, from: prevMonthDate)

                        CellView(day: day, isCurrentMonthDay: false, weekday: weekday)
                    }
                }
                .frame(height: cellHeight)
            }
        }
    }
}

// MARK: 일자 셀 뷰
private struct CellView: View {
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var weekday: Int
    private var textColor: Color {
        if isToday {
            return .white
        } else if !isCurrentMonthDay {
            return .gray
        } else {
            switch weekday {
            case 1: return .red
            case 7: return .blue
            default: return .black
            }
        }
    }
    private var backgroundColor: Color {
        if clicked {
            return Color(.brandColor)
        } else if isToday {
            return Color(.brandColor)
        } else {
            return .white
        }
    }
    
    fileprivate init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true,
        weekday: Int
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self.weekday = weekday
    }
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                if isToday {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 30, height: 30)
                } else if clicked {
                    Circle()
                        .stroke(backgroundColor, lineWidth: 1.5)
                        .frame(width: 30, height: 30)
                }
                
                Text(String(day))
                    .foregroundColor(textColor)
                    .frame(width: 30, height: 30)
            }
            Spacer()
        }
    }
}

private extension CalendarView {
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
}

private extension CalendarView {
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: month),
                month: calendar.component(.month, from: month),
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
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        self.month = adjustedMonth(by: value)
    }
    
    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            return newMonth
        }
        return month
    }
}

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

#Preview {
    CalendarView()
}
