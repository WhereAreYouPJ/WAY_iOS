//
//  ScheduleViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation

class ScheduleViewModel {
    var onScheduleDataFetched: (() -> Void)?
    private var schedules: [Schedule] = []
    private var timer: Timer?
    private var currentIndex = 0
    
    // MARK: - Helpers
    // 데이터 설정 메서드
        func setSchedules(_ schedules: [Schedule]) {
            self.schedules = schedules
            onScheduleDataFetched?()
            startAutoScroll()
        }
    
    func getSchedules() -> [Schedule] {
        return schedules
    }
    
    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextSchedule), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    func daysUntil(date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        return components.day ?? 0
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToNextSchedule() {
        guard !schedules.isEmpty else { return }
        currentIndex = (currentIndex + 1) % (schedules.count + 2) // +2 페이크 셀
        let indexPath = IndexPath(item: currentIndex, section: 0)
        NotificationCenter.default.post(name: .scrollToScheduleIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
}

extension NSNotification.Name {
    static let scrollToScheduleIndex = NSNotification.Name("scrollToScheduleIndex")
}
