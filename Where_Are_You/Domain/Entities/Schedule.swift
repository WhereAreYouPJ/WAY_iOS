//
//  Schedule.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/7/2024.
//

import Foundation

struct Schedule {
    let date: Date
    let title: String
    
    var dDay: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfEventDay = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfEventDay)
        return components.day ?? 0
    }
}
