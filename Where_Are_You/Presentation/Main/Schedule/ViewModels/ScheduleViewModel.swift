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
    
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    private var scheduleRowMapping: [Int: Int] = [:]
    
    private let getMonthlyScheduleUseCase: GetMonthlyScheduleUseCase
    
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
                    self.calculateScheduleRowMapping()
                case .failure(let error):
                    print("월별 스케줄 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // ✅ 더 스마트한 우선순위 정렬 (선택사항)
    private func calculateScheduleRowMapping() {
        scheduleRowMapping.removeAll()
        
        // 1. 개선된 우선순위 정렬
        let sortedSchedules = monthlySchedules.sorted { (a, b) in
            let aIsMultiDay = !Calendar.current.isDate(a.startTime, inSameDayAs: a.endTime)
            let bIsMultiDay = !Calendar.current.isDate(b.startTime, inSameDayAs: b.endTime)
            
            // 우선순위 1: 연속 일정이 단일 일정보다 우선
            if aIsMultiDay != bIsMultiDay {
                return aIsMultiDay
            }
            
            // 우선순위 2: 연속 일정끼리는 긴 일정이 우선
            if aIsMultiDay && bIsMultiDay {
                let aDuration = Calendar.current.dateComponents([.day], from: a.startTime, to: a.endTime).day ?? 0
                let bDuration = Calendar.current.dateComponents([.day], from: b.startTime, to: b.endTime).day ?? 0
                
                if aDuration != bDuration {
                    return aDuration > bDuration
                }
                
                // 우선순위 3: 같은 길이면 시작 날짜가 빠른 것이 우선
                return a.startTime < b.startTime
            }
            
            // 우선순위 4: 단일 일정끼리는 날짜가 빠른 것이 우선
            if !aIsMultiDay && !bIsMultiDay {
                return a.startTime < b.startTime
            }
            
            // 우선순위 5: 마지막으로 ID로 정렬
            return a.scheduleSeq < b.scheduleSeq
        }
        
        // 2. 각 일정에 대해 최적의 행 찾기 (기존과 동일)
        for schedule in sortedSchedules {
            let bestRow = findBestRowForSchedule(schedule, existingMappings: scheduleRowMapping)
            scheduleRowMapping[schedule.scheduleSeq] = bestRow
        }
    }
    
    // ✅ 특정 일정에 대해 최적의 행을 찾는 함수
    private func findBestRowForSchedule(_ schedule: Schedule, existingMappings: [Int: Int]) -> Int {
        let calendar = Calendar.current
        let scheduleStartDate = calendar.startOfDay(for: schedule.startTime)
        let scheduleEndDate = calendar.startOfDay(for: schedule.endTime)
        
        // 각 행(0~3)에 대해 충돌 여부 확인
        for rowIndex in 0..<4 {
            if canPlaceScheduleInRow(schedule, rowIndex: rowIndex, existingMappings: existingMappings) {
                return rowIndex
            }
        }
        
        // 모든 행이 충돌하면 마지막 행(3)에 강제 배치
        return 3
    }
    
    // ✅ 특정 행에 일정을 배치할 수 있는지 확인
    private func canPlaceScheduleInRow(_ schedule: Schedule, rowIndex: Int, existingMappings: [Int: Int]) -> Bool {
        let calendar = Calendar.current
        let scheduleStartDate = calendar.startOfDay(for: schedule.startTime)
        let scheduleEndDate = calendar.startOfDay(for: schedule.endTime)
        
        // 같은 행에 이미 배치된 다른 일정들과 겹치는지 확인
        for otherSchedule in monthlySchedules {
            // 자기 자신은 제외
            if otherSchedule.scheduleSeq == schedule.scheduleSeq {
                continue
            }
            
            // 다른 일정이 같은 행에 배치되어 있는지 확인
            guard existingMappings[otherSchedule.scheduleSeq] == rowIndex else {
                continue
            }
            
            // 날짜 범위가 겹치는지 확인
            let otherStartDate = calendar.startOfDay(for: otherSchedule.startTime)
            let otherEndDate = calendar.startOfDay(for: otherSchedule.endTime)
            
            // 두 일정의 날짜 범위가 겹치면 충돌
            if schedulesOverlap(
                start1: scheduleStartDate, end1: scheduleEndDate,
                start2: otherStartDate, end2: otherEndDate
            ) {
                return false // 충돌 발생
            }
        }
        
        return true // 충돌 없음
    }
    
    // ✅ 두 일정의 날짜 범위가 겹치는지 확인
    private func schedulesOverlap(start1: Date, end1: Date, start2: Date, end2: Date) -> Bool {
        // 일정 A: [start1 ---- end1]
        // 일정 B:     [start2 ---- end2]
        // 겹침 조건: start1 <= end2 && start2 <= end1
        return start1 <= end2 && start2 <= end1
    }
    
    // ✅ 특정 일정의 행 번호 반환
    func getRowIndex(for scheduleSeq: Int) -> Int {
        return scheduleRowMapping[scheduleSeq] ?? 0
    }
}
