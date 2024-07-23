//
//  TimeHelper.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/7/2024.
//

import Foundation

// MARK: - TimerHelper (5분 타이머 설정)
class TimerHelper {
    private var timer: Timer?
    var timerCount: Int = 300
    var onUpdateTimer: ((String) -> Void)?
    var onTimerExpired: (() -> Void)?

    func startTimer() {
        timerCount = 300
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerCount -= 1
            let minutes = self.timerCount / 60
            let seconds = self.timerCount % 60
            let timeString = String(format: "%02d:%02d", minutes, seconds)
            self.onUpdateTimer?(timeString)
            if self.timerCount == 0 {
                self.stopTimer()
                self.onTimerExpired?()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
