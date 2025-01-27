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
    func configureNavigationBar(title: String, backButtonAction: Selector? = nil, showBackButton: Bool = true) {
        Utilities.createNavigationBar(for: self, title: title, backButtonAction: backButtonAction, showBackButton: showBackButton)
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

// MARK: - UIFont

extension UIFont {
    struct CustomFont {
        static func titleH1(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 22)!,
                lineHeight: 1.3,
                letterSpacing: -2,
                textColor: textColor
            )
        }
        
        static func titleH2(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 20)!,
                lineHeight: 1.3,
                letterSpacing: -2,
                textColor: textColor
            )
        }
        
        static func titleH3(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 18)!,
                lineHeight: 1.3,
                letterSpacing: -1,
                textColor: textColor
            )
        }
        
        static func bodyP1(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: 20)!,
                lineHeight: 1.4,
                letterSpacing: -1,
                textColor: textColor
            )
        }
        
        static func bodyP2(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-SemiBold", size: 18)!,
                lineHeight: 1.4,
                letterSpacing: 0,
                textColor: textColor
            )
        }
        
        static func bodyP3(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: 16)!,
                lineHeight: 1.4,
                letterSpacing: -0.5,
                textColor: textColor
            )
        }
        
        static func bodyP4(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: 14)!,
                lineHeight: 1.4,
                letterSpacing: -0.5,
                textColor: textColor
            )
        }
        
        static func bodyP5(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Pretendard-Medium", size: 12)!,
                lineHeight: 1.3,
                letterSpacing: -1.25,
                textColor: textColor
            )
        }
        
        static func button18(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 18)!,
                lineHeight: 1.3,
                letterSpacing: 1.25,
                textColor: textColor
            )
        }
        
        static func button16(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 16)!,
                lineHeight: 1.3,
                letterSpacing: 4,
                textColor: textColor
            )
        }
        
        static func button14(text: String, textColor: UIColor) -> NSAttributedString {
            return attributedFont(
                text: text,
                font: UIFont(name: "Paperlogy-6SemiBold", size: 14)!,
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
    
    func toURL() -> URL? {
        // 로컬 임시 디렉토리에 저장할 파일 경로 생성
        guard let data = self.jpegData(compressionQuality: 0.8) else { return nil }
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            // UIImage 데이터를 파일로 저장
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("이미지를 로컬 파일로 저장하는 중 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - UIImageView

extension UIImageView {
    func setImage(from urlString: String?, placeholder: UIImage? = UIImage(named: "basic_profile_image")) {
        // URL 검증 및 기본 이미지 설정
        guard let urlString = urlString, !urlString.isEmpty else {
            self.image = placeholder
            return
        }
        
        // ImageLoader를 통해 이미지 로드
        ImageLoader.shared.loadImage(from: urlString) { [weak self] loadedImage in
            DispatchQueue.main.async {
                self?.image = loadedImage ?? placeholder
            }
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
    case server = "yyyy-MM-dd'T'HH:mm:ss.SSS" // 서버의 날짜 형식
    case serverSimple = "yyyy-MM-dd'T'HH:mm:ss"
    case yearMonthDate = "yy.MM.dd"                // "YY.MM.dd" 형태
    case yearMonth = "yyyy.MM"               // "YYYY.MM" 형태
    case monthDay = "MM월 dd일"               // "MM월 dd일" 형태
}

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
}

// MARK: - Notification

extension Notification.Name {
    static let showAddFriend = Notification.Name("showAddFriend")
    static let showManageFriends = Notification.Name("showManageFriends")
}

// MARK: View to UIImage - 실시간 위치 조회시 프로필사진 마킹용
extension View {
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
}

// MARK: - UILabel

extension UILabel {

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        guard let text = self.text, !text.isEmpty else { return }

        // Calculate visible text length
        let visibleLength = calculateVisibleTextLength()
        guard visibleLength > 0, visibleLength < text.count else { return }

        let trimmedText = (text as NSString).substring(to: visibleLength)
        let trailing = trailingText + moreText

        guard trimmedText.count > trailing.count else { return }

        let finalText = (trimmedText as NSString).replacingCharacters(
            in: NSRange(location: trimmedText.count - trailing.count, length: trailing.count),
            with: trailingText
        )

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
        
        let sizeConstraint = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = (text as NSString).boundingRect(
            with: sizeConstraint,
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.font!],
            context: nil
        )

        if boundingRect.height <= self.frame.height {
            return text.count
        }

        var index = 0
        var prevIndex = 0
        let characterSet = CharacterSet.whitespacesAndNewlines

        repeat {
            prevIndex = index
            index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location

            let substring = (text as NSString).substring(to: index)
            let height = (substring as NSString).boundingRect(
                with: sizeConstraint,
                options: .usesLineFragmentOrigin,
                attributes: [.font: self.font!],
                context: nil
            ).height

            if height > self.frame.height {
                break
            }
        } while index != NSNotFound

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
}
