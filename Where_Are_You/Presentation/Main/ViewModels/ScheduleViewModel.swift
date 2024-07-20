//
//  ScheduleViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation

class ScheduleViewModel {
    var onScheduleDataFetched: (() -> Void)?
    private var schedules: [String] = []
    private var timer: Timer?
    private var currentIndex = 0
    
    // MARK: - Helpers

    func fetchSchedules() {
        // API통신으로 데이터 받기
        // 받은 데이터 schedules에 업데이트하기
        self.schedules = [
            "D - 369 96조 여의도 한강공원 모임",
            "D - 100 96조 워크숍"
        ]
        onScheduleDataFetched?()
        startAutoScroll()
    }
    
    func getSchedules() -> [String] {
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
