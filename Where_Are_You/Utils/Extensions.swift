//
//  Extensions.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SwiftUI

// MARK: - UIViewController

enum FeedViewType {
    case mainFeed
    case bookMark
    case archive
}

extension UIViewController {
    func configureNavigationBar(title: String, backButtonAction: Selector? = nil, showBackButton: Bool = true, rightButton: UIBarButtonItem? = nil) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        Utilities.createNavigationBar(for: self, title: title, backButtonAction: backButtonAction, showBackButton: showBackButton, rightButton: rightButton)
    }
    
    func pushToViewController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func rootToViewcontroller(_ controller: UIViewController) {
        let nav = UINavigationController(rootViewController: controller)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = nav
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil)
            window.makeKeyAndVisible()
        }
    }
    
    func pushAndHideTabViewController(_ controller: UIViewController) {
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let brandMain = UIColor.rgb(red: 129, green: 97, blue: 246)
    static let brandDark = UIColor.rgb(red: 115, green: 78, blue: 227)
    static let brandDark2 = UIColor.rgb(red: 116, green: 92, blue: 200)
    static let brandLight = UIColor.rgb(red: 191, green: 173, blue: 255)
    static let brandHighLight1 = UIColor.rgb(red: 240, green: 235, blue: 255)
    static let brandHighLight2 = UIColor.rgb(red: 245, green: 242, blue: 255)
    
    static let black22 = UIColor.rgb(red: 34, green: 34, blue: 34)
    static let black44 = UIColor.rgb(red: 68, green: 68, blue: 68)
    static let black66 = UIColor.rgb(red: 102, green: 102, blue: 102)
    static let blackAC = UIColor.rgb(red: 172, green: 172, blue: 172)
    static let blackD4 = UIColor.rgb(red: 201, green: 201, blue: 201)
    static let blackF0 = UIColor.rgb(red: 240, green: 240, blue: 240)
    static let blackF8 = UIColor.rgb(red: 248, green: 248, blue: 248)
    
    static let calendarRed = UIColor.rgb(red: 248, green: 173, blue: 174)
    static let calendarOrange = UIColor.rgb(red: 250, green: 209, blue: 127)
    static let calendarYellow = UIColor.rgb(red: 244, green: 244, blue: 162)
    static let calendarGreen = UIColor.rgb(red: 207, green: 234, blue: 152)
    static let calendarMint = UIColor.rgb(red: 161, green: 226, blue: 204)
    static let calendarBlue = UIColor.rgb(red: 178, green: 209, blue: 255)
    static let calendarPink = UIColor.rgb(red: 246, green: 171, blue: 224)
    static let calendarPurple = UIColor.rgb(red: 184, green: 168, blue: 255)
    
    static let error = UIColor.rgb(red: 225, green: 49, blue: 49)
    
    static let secondaryNormal = UIColor.rgb(red: 255, green: 226, blue: 83)
    static let secondaryDark = UIColor.rgb(red: 242, green: 206, blue: 0)
    static let secondaryLight = UIColor.rgb(red: 255, green: 238, blue: 156)
    
    // 여기부터 예전버전 컬러.
    static let brandColor = UIColor.rgb(red: 123, green: 80, blue: 255)
    static let letterBrandColor = UIColor.rgb(red: 98, green: 54, blue: 233)
    static let lightpurple = UIColor.rgb(red: 146, green: 134, blue: 255)
    static let scheduleDateColor = UIColor.rgb(red: 252, green: 47, blue: 47)
    static let popupButtonColor = UIColor.rgb(red: 81, green: 70, blue: 117)
    static let alertActionButtonColor = UIColor.rgb(red: 212, green: 158, blue: 255)
    
    static let color5 = UIColor.rgb(red: 5, green: 5, blue: 5)
    static let color17 = UIColor.rgb(red: 17, green: 17, blue: 17)
    static let color29 = UIColor.rgb(red: 29, green: 29, blue: 29)
    static let color51 = UIColor.rgb(red: 51, green: 51, blue: 51)
    static let color5769 = UIColor.rgb(red: 57, green: 69, blue: 255)
    static let color57125 = UIColor.rgb(red: 57, green: 125, blue: 255)
    static let color81 = UIColor.rgb(red: 81, green: 70, blue: 117)
    static let color118 = UIColor.rgb(red: 118, green: 118, blue: 118)
    static let color153 = UIColor.rgb(red: 153, green: 153, blue: 153)
    static let color160 = UIColor.rgb(red: 160, green: 160, blue: 160)
    static let color171 = UIColor.rgb(red: 171, green: 171, blue: 171)
    static let color190 = UIColor.rgb(red: 190, green: 190, blue: 190)
    static let color191 = UIColor.rgb(red: 191, green: 191, blue: 191)
    static let color212 = UIColor.rgb(red: 212, green: 212, blue: 212)
    static let color217 = UIColor.rgb(red: 217, green: 217, blue: 217)
    static let color221 = UIColor.rgb(red: 221, green: 221, blue: 221)
    static let color223 = UIColor.rgb(red: 223, green: 223, blue: 223)
    static let color231 = UIColor.rgb(red: 231, green: 231, blue: 231)
    static let color235 = UIColor.rgb(red: 235, green: 235, blue: 235)
    static let color242 = UIColor.rgb(red: 242, green: 242, blue: 242)
    static let color249 = UIColor.rgb(red: 249, green: 249, blue: 249)
    static let color255125 = UIColor.rgb(red: 255, green: 125, blue: 150)
    static let color25569 = UIColor.rgb(red: 255, green: 69, blue: 69)
}

// MARK: Color

extension Color {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> Color {
        return Color(red: red/255, green: green/255, blue: blue/255)
    }
    static let brandMain = Color.rgb(red: 129, green: 97, blue: 246)
    static let brandDark = Color.rgb(red: 115, green: 78, blue: 227)
    static let brandDark2 = Color.rgb(red: 116, green: 92, blue: 200)
    static let brandLight = Color.rgb(red: 191, green: 173, blue: 255)
    static let brandHighLight1 = Color.rgb(red: 240, green: 235, blue: 255)
    static let brandHighLight2 = Color.rgb(red: 245, green: 242, blue: 255)
    
    static let black22 = Color.rgb(red: 34, green: 34, blue: 34)
    static let black44 = Color.rgb(red: 68, green: 68, blue: 68)
    static let black66 = Color.rgb(red: 102, green: 102, blue: 102)
    static let blackAC = Color.rgb(red: 172, green: 172, blue: 172)
    static let blackD4 = Color.rgb(red: 201, green: 201, blue: 201)
    static let blackF0 = Color.rgb(red: 240, green: 240, blue: 240)
    static let blackF8 = Color.rgb(red: 248, green: 248, blue: 248)
    
    static let calendarRed = Color.rgb(red: 248, green: 173, blue: 174)
    static let calendarOrange = Color.rgb(red: 250, green: 209, blue: 127)
    static let calendarYellow = Color.rgb(red: 244, green: 244, blue: 162)
    static let calendarGreen = Color.rgb(red: 207, green: 234, blue: 152)
    static let calendarMint = Color.rgb(red: 161, green: 226, blue: 204)
    static let calendarBlue = Color.rgb(red: 178, green: 209, blue: 255)
    static let calendarPink = Color.rgb(red: 246, green: 171, blue: 224)
    static let calendarPurple = Color.rgb(red: 184, green: 168, blue: 255)
    
    static let error = Color.rgb(red: 225, green: 49, blue: 49)
    
    static let secondaryNormal = Color.rgb(red: 255, green: 226, blue: 83)
    static let secondaryDark = Color.rgb(red: 242, green: 206, blue: 0)
    static let secondaryLight = Color.rgb(red: 255, green: 238, blue: 156)
    
    static let brandColor = Color.rgb(red: 123, green: 80, blue: 255)
    static let letterBrandColor = Color.rgb(red: 98, green: 54, blue: 233)
    static let lightpurple = Color.rgb(red: 146, green: 134, blue: 255)
    static let scheduleDateColor = Color.rgb(red: 252, green: 47, blue: 47)
    static let popupButtonColor = Color.rgb(red: 81, green: 70, blue: 117)
    static let alertActionButtonColor = Color.rgb(red: 212, green: 158, blue: 255)
}

// MARK: - UIFont

extension UIFont {
    struct CustomFont {
        static func titleH1(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 22))!,
                lineHeight: 1.3,
                letterSpacing: -2,
                textColor: textColor
            )
        }
        
        static func titleH2(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 20))!,
                lineHeight: 1.3,
                letterSpacing: -2,
                textColor: textColor
            )
        }
        
        static func titleH3(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 18))!,
                lineHeight: 1.3,
                letterSpacing: -1,
                textColor: textColor
            )
        }
        
        static func bodyP1(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: LayoutAdapter.shared.scale(value: 20))!,
                lineHeight: 1.4,
                letterSpacing: -1,
                textColor: textColor
            )
        }
        
        static func bodyP2(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-SemiBold", size: LayoutAdapter.shared.scale(value: 18))!,
                lineHeight: 1.4,
                letterSpacing: 0,
                textColor: textColor
            )
        }
        
        static func bodyP3(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: LayoutAdapter.shared.scale(value: 16))!,
                lineHeight: 1.4,
                letterSpacing: -0.5,
                textColor: textColor
            )
        }
        
        static func bodyP4(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: LayoutAdapter.shared.scale(value: 14))!,
                lineHeight: 1.4,
                letterSpacing: -0.5,
                textColor: textColor
            )
        }
        
        static func bodyP5(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: LayoutAdapter.shared.scale(value: 12))!,
                lineHeight: 1.3,
                letterSpacing: -1.25,
                textColor: textColor
            )
        }
        
        static func button18(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 18))!,
                lineHeight: 1.3,
                letterSpacing: 1.25,
                textColor: textColor
            )
        }
        
        static func button16(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 16))!,
                lineHeight: 1.3,
                letterSpacing: 4,
                textColor: textColor
            )
        }
        
        static func button14(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: LayoutAdapter.shared.scale(value: 14))!,
                lineHeight: 1.3,
                letterSpacing: -0.5,
                textColor: textColor
            )
        }
        
        private static func attributedFont(
            text: String,
            font: UIFont,
            lineHeight: CGFloat,
            letterSpacing: CGFloat,
            textColor: UIColor
        ) -> NSAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = font.lineHeight * lineHeight
            paragraphStyle.minimumLineHeight = font.lineHeight * lineHeight
            // https://sujinnaljin.medium.com/swift-label%EC%9D%98-line-height-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EA%B0%80%EC%9A%B4%EB%8D%B0-%EC%A0%95%EB%A0%AC-962f7c6e7512여기서 LineHeight설정시 아래에 깔리는 문제 해결
            let letterSpacingPt = letterSpacing / UIScreen.main.scale // px -> pt 변환
            
            return NSAttributedString(
                string: text,
                attributes: [
                    .font: font,
                    .paragraphStyle: paragraphStyle,
                    .kern: letterSpacingPt,
                    .foregroundColor: textColor,
                    .baselineOffset: (font.lineHeight * lineHeight - font.lineHeight) / 2
                ]
            )
        }
    }
    
    static func pretendard(Ttangsbudae weight: UIFont.Weight, fontSize: CGFloat) -> UIFont {
        
        var weightString: String
        
        switch weight {
        case .bold:
            weightString = "OTTtangsbudaejjigaeB"
        case .light:
            weightString = "OTTtangsbudaejjigaeL"
        case .medium:
            weightString = "OTTtangsbudaejjigaeLM"
        default:
            weightString = "Regular"
        }
        
        return UIFont(name: "\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
    
    static func pretendard(NotoSans weight: UIFont.Weight, fontSize: CGFloat) -> UIFont {
        
        var weightString: String
        
        switch weight {
        case .bold:
            weightString = "NotoSansKR-Bold"
        case .light:
            weightString = "NotoSansKR-Light"
        case .medium:
            weightString = "NotoSansKR-Medium"
        default:
            weightString = "Regular"
        }
        
        return UIFont(name: "\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}

// MARK: - Font

extension Font {
    // Title Fonts
    static func titleH1() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 22),
            lineHeight: 1.3,
            letterSpacing: -1
        )
    }
    
    static func titleH2() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 20),
            lineHeight: 1.3,
            letterSpacing: -2
        )
    }
    
    static func titleH3() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 18),
            lineHeight: 1.3,
            letterSpacing: -1
        )
    }
    
    // Body Fonts
    static func bodyP1() -> FontStyle {
        return FontStyle(
            family: "Pretendard-Medium",
            size: LayoutAdapter.shared.scale(value: 20),
            lineHeight: 1.4,
            letterSpacing: -1
        )
    }
    
    static func bodyP2() -> FontStyle {
        return FontStyle(
            family: "Pretendard-SemiBold",
            size: LayoutAdapter.shared.scale(value: 18),
            lineHeight: 1.4,
            letterSpacing: 0
        )
    }
    
    static func bodyP3() -> FontStyle {
        return FontStyle(
            family: "Pretendard-Medium",
            size: LayoutAdapter.shared.scale(value: 16),
            lineHeight: 1.4,
            letterSpacing: -0.5
        )
    }
    
    static func bodyP4() -> FontStyle {
        return FontStyle(
            family: "Pretendard-Medium",
            size: LayoutAdapter.shared.scale(value: 14),
            lineHeight: 1.4,
            letterSpacing: -0.5
        )
    }
    
    static func bodyP5() -> FontStyle {
        return FontStyle(
            family: "Pretendard-Medium",
            size: LayoutAdapter.shared.scale(value: 12),
            lineHeight: 1.3,
            letterSpacing: -1.25
        )
    }
    
    // Button Fonts
    static func button18() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 18),
            lineHeight: 1.3,
            letterSpacing: 1.25
        )
    }
    
    static func button16() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 16),
            lineHeight: 1.3,
            letterSpacing: 4
        )
    }
    
    static func button14() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 14),
            lineHeight: 1.3,
            letterSpacing: -0.5
        )
    }
    
    static func button9() -> FontStyle {
        return FontStyle(
            family: "Paperlogy-6SemiBold",
            size: LayoutAdapter.shared.scale(value: 9),
            lineHeight: 1.3,
            letterSpacing: -1.25
        )
    }
    
    // Custom Fonts
    static func ttangsbudae(weight: Font.Weight, size: CGFloat) -> Font {
        let weightString: String
        
        switch weight {
        case .bold:
            weightString = "OTTtangsbudaejjigaeB"
        case .light:
            weightString = "OTTtangsbudaejjigaeL"
        case .medium:
            weightString = "OTTtangsbudaejjigaeLM"
        default:
            weightString = "Regular"
        }
        
        return Font.custom(weightString, size: size)
    }
    
    static func notoSans(weight: Font.Weight, size: CGFloat) -> Font {
        let weightString: String
        
        switch weight {
        case .bold:
            weightString = "NotoSansKR-Bold"
        case .light:
            weightString = "NotoSansKR-Light"
        case .medium:
            weightString = "NotoSansKR-Medium"
        default:
            weightString = "Regular"
        }
        
        return Font.custom(weightString, size: size)
    }
    
    static func pretendard(NotoSans weight: Font.Weight, fontSize: CGFloat) -> Font {
        let uiFontWeight: UIFont.Weight
        switch weight {
        case .regular: uiFontWeight = .regular
        case .bold: uiFontWeight = .bold
        case .light: uiFontWeight = .light
        case .medium: uiFontWeight = .medium
        default: uiFontWeight = .regular
        }
        return Font(UIFont.pretendard(NotoSans: uiFontWeight, fontSize: fontSize))
    }
}

// Text 확장 - prompt와 같은 특별한 경우를 위한 스타일 메서드
extension Text {
    func withFontStyle(_ style: FontStyle, color: Color = .primary) -> Text {
        return self.font(style.font)
                  .foregroundColor(color)
                  // lineSpacing과 kerning은 여기서 적용하지 않음
                  // (Text 타입의 특성상 이후 chaining이 필요함)
    }
    
    // 다른 스타일 메서드들도 동일한 패턴으로 구현
    func withTitleH1Style(color: Color = .primary) -> Text {
        return withFontStyle(Font.titleH1(), color: color)
    }
    
    func withBodyP2Style(color: Color = .primary) -> Text {
        return withFontStyle(Font.bodyP2(), color: color)
    }
    
    func withBodyP3Style(color: Color = .primary) -> Text {
        return withFontStyle(Font.bodyP3(), color: color)
    }
    
    func withBodyP4Style(color: Color = .primary) -> Text {
        return withFontStyle(Font.bodyP4(), color: color)
    }
}

// MARK: - UIImage

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedForProfile(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static func formatter(for format: DateFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
}

enum DateFormat: String {
    case server = "yyyy-MM-dd'T'HH:mm:ss.SSS"   // 서버의 날짜 형식
    case serverSimple = "yyyy-MM-dd'T'HH:mm:ss" // 서버의 날짜 형식
    case yearMonthDateHyphen = "yyyy-MM-dd"     // "yyyy-MM-dd" 형태
    case yearMonthDateDot = "yyyy.MM.dd"     // "yyyy-MM-dd" 형태
    case yearMonthDate = "yy.MM.dd"             // "YY.MM.dd" 형태
    case yearMonthHyphen = "yyyy-MM"                  // "YYYY-MM" 형태
    case yearMonth = "yyyy년 M월"                  // "2025년 1월" 형태
    case monthDay = "MM월 dd일"                  // "MM월 dd일" 형태
    case monthDaySimple = "M월 d일"              // "M월 d일" 형태
    case time = "a h시 m분"                      // "오후 1시 1분" 형태
    case timeColon = "a h:mm"                      // "오후 1:01" 형태
    case timeSimple = "a h시"                   // "오후 1시" 형태
}

// MARK: - Date

extension Date {
    func formatted(to format: DateFormat) -> String {
        return DateFormatter.formatter(for: format).string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: self, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "1일 전" : "\(day)일 전"
        }
        
        if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1시간 전" : "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1분 전" : "\(minute)분 전"
        }
        
        return "방금 전"
    }
    
    func determineTimeFormat() -> DateFormat {
        return Calendar.current.component(.minute, from: self) == 0 ? .timeSimple : .time
    }
    
    static var yearRange2000To2100: ClosedRange<Date> {
        let calendar = Calendar.current
        let minDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        let maxDate = calendar.date(from: DateComponents(year: 2100, month: 12, day: 31))!
        return minDate...maxDate
    }
    
    // 날짜의 년/월/일 컴포넌트만 추출 (시간대는 한국으로 고정)
    var ymd: DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        return calendar.dateComponents([.year, .month, .day], from: self)
    }
    
    // 두 날짜의 년/월/일이 동일한지 비교 (시간 무시)
    func isSameYMD(as otherDate: Date) -> Bool {
        let myComponents = self.ymd
        let otherComponents = otherDate.ymd
        
        return myComponents.year == otherComponents.year &&
               myComponents.month == otherComponents.month &&
               myComponents.day == otherComponents.day
    }
    
    // 년/월/일 컴포넌트로부터 날짜 생성 (정확한 날짜 보장)
    static func fromYMD(year: Int, month: Int, day: Int) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12  // 정오로 설정하여 일관성 확보
        
        return calendar.date(from: components)
    }
    
    // 디버깅용 날짜 표현 (한국 시간대 기준)
    var koreaDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}

// MARK: - String

extension String {
    func formattedDate(to format: DateFormat) -> String {
        guard let date = DateFormatter.formatter(for: .server).date(from: self) else {
            return self // 변환 실패 시 원래 문자열 반환
        }
        return DateFormatter.formatter(for: format).string(from: date)
    }
    
    func toDate(from format: DateFormat = .serverSimple) -> Date? {
        return DateFormatter.formatter(for: format).date(from: self)
    }
}

// MARK: - Notification

extension Notification.Name {
    static let showAddFriend = Notification.Name("showAddFriend")
    static let showManageFriends = Notification.Name("showManageFriends")
}

// MARK: - View
extension View {
    // View to UIImage - 실시간 위치 조회시 프로필사진 마킹용
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    // 폰트 스타일 적용을 위한 모디파이어
    func applyFontStyle(_ style: FontStyle, color: Color = .primary) -> some View {
        let lineSpacing = (style.lineHeight - 1) * style.fontSize
        
        return self
            .font(style.font)
            .lineSpacing(lineSpacing)
            .kerning(style.letterSpacing)
            .foregroundColor(color)
    }
    
    // 키보드 닫기
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // 헤더 스타일 적용 메서드
    func titleH1Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.titleH1(), color: color)
    }
    
    func titleH2Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.titleH2(), color: color)
    }
    
    func titleH3Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.titleH3(), color: color)
    }
    
    // 본문 스타일 적용 메서드
    func bodyP1Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.bodyP1(), color: color)
    }
    
    func bodyP2Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.bodyP2(), color: color)
    }
    
    func bodyP3Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.bodyP3(), color: color)
    }
    
    func bodyP4Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.bodyP4(), color: color)
    }
    
    func bodyP5Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.bodyP5(), color: color)
    }
    
    // 버튼 스타일 적용 메서드
    func button18Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.button18(), color: color)
    }
    
    func button16Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.button16(), color: color)
    }
    
    func button14Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.button14(), color: color)
    }
    
    func button9Style(color: Color = .primary) -> some View {
        applyFontStyle(Font.button9(), color: color)
    }
}

// MARK: - UILabel

extension UILabel {
    //    // "... 더보기" 관련 로직
    //    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
    //        guard let text = self.text, !text.isEmpty else { return }
    //
    //        // Calculate visible text length
    //        let visibleLength = calculateVisibleTextLength()
    //        guard visibleLength > 0, visibleLength < text.count else { return }
    //
    //        let trimmedText = (text as NSString).substring(to: visibleLength)
    //        let trailing = trailingText + moreText
    //
    //        guard trimmedText.count > trailing.count else { return }
    //
    //        let finalText = (trimmedText as NSString).replacingCharacters(
    //            in: NSRange(location: trimmedText.count - trailing.count, length: trailing.count),
    //            with: trailingText
    //        )
    //
    //        let attributedString = NSMutableAttributedString(string: finalText, attributes: [
    //            .font: self.font ?? UIFont.systemFont(ofSize: 14),
    //            .foregroundColor: self.textColor ?? UIColor.black
    //        ])
    //
    //        let moreAttributedString = NSAttributedString(string: moreText, attributes: [
    //            .font: moreTextFont,
    //            .foregroundColor: moreTextColor
    //        ])
    //        attributedString.append(moreAttributedString)
    //
    //        self.attributedText = attributedString
    //    }
    //
    //    private func calculateVisibleTextLength() -> Int {
    //        guard let text = self.text, !text.isEmpty else { return 0 }
    //
    //        self.layoutIfNeeded()
    //
    //        let sizeConstraint = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
    //        let boundingRect = (text as NSString).boundingRect(
    //            with: sizeConstraint,
    //            options: .usesLineFragmentOrigin,
    //            attributes: [.font: self.font!],
    //            context: nil
    //        )
    //
    //        if boundingRect.height <= self.frame.height {
    //            return text.count
    //        }
    //
    //        var index = 0
    //        var prevIndex = 0
    //        let characterSet = CharacterSet.whitespacesAndNewlines
    //
    //        repeat {
    //            prevIndex = index
    //            index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
    //
    //            let substring = (text as NSString).substring(to: index)
    //            let height = (substring as NSString).boundingRect(
    //                with: sizeConstraint,
    //                options: .usesLineFragmentOrigin,
    //                attributes: [.font: self.font!],
    //                context: nil
    //            ).height
    //
    //            if height > self.frame.height {
    //                break
    //            }
    //        } while index != NSNotFound
    //
    //        return prevIndex
    //    }
    // "... 더보기" 관련 로직
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        guard let text = self.text, !text.isEmpty else { return }
        
        let computedVisibleLength = calculateVisibleTextLength()
        let visibleLength = min(computedVisibleLength, text.count)
        
        guard visibleLength > 0, visibleLength < text.count else { return }
        
        let trimmedText = (text as NSString).substring(to: visibleLength)
        let trailing = trailingText + moreText
        
        guard trimmedText.count > trailing.count else { return }
        
        let rangeLocation = trimmedText.count - trailing.count
        let safeRange = NSRange(location: rangeLocation, length: trailing.count)
        let finalText = (trimmedText as NSString).replacingCharacters(in: safeRange, with: trailingText)
        
        let attributedString = NSMutableAttributedString(string: finalText, attributes: [
            .font: self.font ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: self.textColor ?? UIColor.black
        ])
        
        let moreAttributedString = NSAttributedString(string: moreText, attributes: [
            .font: moreTextFont,
            .foregroundColor: moreTextColor
        ])
        attributedString.append(moreAttributedString)
        
        self.attributedText = attributedString
    }
    
    private func calculateVisibleTextLength() -> Int {
        guard let text = self.text, !text.isEmpty else { return 0 }
        
        self.layoutIfNeeded()
        
        // 만약 self.frame.height가 0이라면 intrinsicContentSize.height 사용
//        let labelHeight = self.frame.height > 0 ? self.frame.height : self.intrinsicContentSize.height
        // numberOfLines가 설정되어 있으면, 최대 높이를 그에 맞게 계산
            let maxHeight: CGFloat
            if self.numberOfLines > 0 {
                maxHeight = font.lineHeight * CGFloat(self.numberOfLines)
            } else {
                maxHeight = self.frame.height > 0 ? self.frame.height : self.intrinsicContentSize.height
            }
        
        let sizeConstraint = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = (text as NSString).boundingRect(
            with: sizeConstraint,
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.font!],
            context: nil
        )
        
        // 전체 텍스트가 이미 보인다면
        if boundingRect.height <= maxHeight {
            return text.count
        }
        
        var index = 0
        var prevIndex = 0
        let characterSet = CharacterSet.whitespacesAndNewlines
        
        repeat {
            prevIndex = index
            
            // 다음 공백을 찾기 위한 범위를 계산
            let searchRange = NSRange(location: index + 1, length: text.count - index - 1)
            let foundRange = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: searchRange)
            
            // 만약 공백을 찾지 못했다면, 인덱스를 텍스트 전체 길이로 설정하고 종료
            if foundRange.location == NSNotFound {
                index = text.count
                break
            } else {
                index = foundRange.location
            }
            
            //            index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
            
            let substring = (text as NSString).substring(to: index)
            let height = (substring as NSString).boundingRect(
                with: sizeConstraint,
                options: .usesLineFragmentOrigin,
                attributes: [.font: self.font!],
                context: nil
            ).height
            
            if height > maxHeight {
                break
            }
        } while index < text.count
        
        return prevIndex
    }
}

extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        var superview = self.superview
        while superview != nil {
            if let targetSuperview = superview as? T {
                return targetSuperview
            }
            superview = superview?.superview
        }
        return nil
    }
    
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let responder = subview.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}

// MARK: - Calendar 시간대를 한국으로 고정
extension Calendar {
    static var koreaCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        return calendar
    }
}
