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
    
    func fetchSchedules() {
        // Fetch schedules from the API
        // Update schedules array
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
    
    @objc private func scrollToNextSchedule() {
        guard !schedules.isEmpty else { return }
        currentIndex = (currentIndex + 1) % schedules.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        NotificationCenter.default.post(name: .scrollToScheduleIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
}

extension NSNotification.Name {
    static let scrollToScheduleIndex = NSNotification.Name("scrollToScheduleIndex")
}
