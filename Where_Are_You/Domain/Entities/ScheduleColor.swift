//
//  ScheduleColor.swift
//  Where_Are_You
//
//  Created by juhee on 25.03.25.
//

import SwiftUI

struct ScheduleColor {
    // 색상 키 열거형
    enum ColorKey: String, CaseIterable {
        case red
        case orange
        case yellow
        case green
        case mint
        case blue
        case pink
        case purple
        
        // UIColor로 변환
        var uiColor: UIColor {
            switch self {
            case .red: return UIColor.calendarRed
            case .orange: return UIColor.calendarOrange
            case .yellow: return UIColor.calendarYellow
            case .green: return UIColor.calendarGreen
            case .mint: return UIColor.calendarMint
            case .blue: return UIColor.calendarBlue
            case .pink: return UIColor.calendarPink
            case .purple: return UIColor.calendarPurple
            }
        }
        
        // SwiftUI Color로 변환
        var color: Color {
            return Color(uiColor)
        }
    }
    
    // 모든 색상과 이름 배열 가져오기
    static var allColorsWithNames: [(Color, String)] {
        return ColorKey.allCases.map { ($0.color, $0.rawValue) }
    }
    
    // 문자열에서 Color로 변환
    static func color(from string: String) -> Color {
        guard let colorKey = ColorKey(rawValue: string) else {
            return ColorKey.red.color // 기본값
        }
        return colorKey.color
    }
    
    // Color에서 문자열로 변환
    static func string(from color: Color) -> String? {
        for colorKey in ColorKey.allCases {
            // SwiftUI Color 비교는 쉽지 않으므로 색상 식별자를 기준으로 비교
            if color == colorKey.color {
                return colorKey.rawValue
            }
        }
        return nil
    }
}

// 사용 예시
// let myColor = CalendarColor.color(from: "blue")
// let colorName = CalendarColor.string(from: myColor)
// let allColors = CalendarColor.allColorsWithNames
