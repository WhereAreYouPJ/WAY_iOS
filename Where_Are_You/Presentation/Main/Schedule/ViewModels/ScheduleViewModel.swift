//
//  CalendarViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 31.08.24.
//

import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var month: Date = Date()
    @Published var selectedDate: Date?
    @Published var monthlySchedules: [Schedule] = []
    @Published var dailySchedules: [Schedule] = []
    @Published var isLoading = false
    
    private let getMonthlyScheduleUseCase: GetMonthlyScheduleUseCase
    
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    init(getMonthlyScheduleUseCase: GetMonthlyScheduleUseCase) {
        self.getMonthlyScheduleUseCase = getMonthlyScheduleUseCase
    }
    
    // 일정 생성을 위한 기본 날짜 반환
    func getDateForNewSchedule() -> Date {
        // 1. 선택된 날짜가 있다면 해당 날짜
        if let selected = selectedDate {
            print("📆 날짜 선택됨: \(selected)")
            return selected
        }
        
        // 2. 선택된 날짜가 없으면 오늘 날짜
        return Date()
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            month = newMonth
            selectedDate = nil
            getMonthlySchedule()
        }
    }
    
    func hasSchedules(for date: Date) -> Bool {
        let dayStart = Calendar.current.startOfDay(for: date)
        return monthlySchedules.contains { schedule in
            let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
            let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
            return (scheduleStartDate...scheduleEndDate).contains(dayStart)
        }
    }
    
    func getMonthlySchedule() {
        isLoading = true
        let yearMonth = month.formatted(to: .yearMonthHyphen)
        
        getMonthlyScheduleUseCase.execute(yearMonth: yearMonth) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let schedules):
                    self.monthlySchedules = schedules
                case .failure(let error):
                    print("월별 스케줄 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
