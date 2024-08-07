//
//  DDayViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation

class DDayViewModel {
    var onDDayDataFetched: (() -> Void)?
    private var dDays: [DDay] = []
    private var timer: Timer?
    private var currentIndex = 0
    
    // MARK: - Helpers
    // 데이터 설정 메서드
        func setDDays(_ dDays: [DDay]) {
            self.dDays = dDays
            onDDayDataFetched?()
            startAutoScroll()
        }
    
    func getDDays() -> [DDay] {
        return dDays
    }
    
    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextDDay), userInfo: nil, repeats: true)
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
    
    @objc private func scrollToNextDDay() {
        guard !dDays.isEmpty else { return }
        currentIndex = (currentIndex + 1) % (dDays.count + 2) // +2 페이크 셀
        let indexPath = IndexPath(item: currentIndex, section: 0)
        NotificationCenter.default.post(name: .scrollToDDayIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
}

extension NSNotification.Name {
    static let scrollToDDayIndex = NSNotification.Name("scrollToDDayIndex")
}
