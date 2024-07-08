//
//  Extensions.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

// MARK: - 로그인 확인을 위한 UserDefaults 확장

extension UserDefaults {
    private enum keys {
        static let isLoggedIn = "isLoggedIn"
    }
    
    var isLoggedIn: Bool {
        get {
            return bool(forKey: keys.isLoggedIn)
        }
        set {
            set(newValue, forKey: keys.isLoggedIn)
        }
    }
}

// MARK: - UIViewController
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
    
    static let brandColor = UIColor.rgb(red: 123, green: 80, blue: 255)
    static let letterBrandColor = UIColor.rgb(red: 98, green: 54, blue: 233)
    static let lightpurple = UIColor.rgb(red: 146, green: 134, blue: 255)
    static let warningColor = UIColor.rgb(red: 223, green: 67, blue: 67)
    
    static let color17 = UIColor.rgb(red: 17, green: 17, blue: 17)
    static let color34 = UIColor.rgb(red: 34, green: 34, blue: 34)
    static let color51 = UIColor.rgb(red: 51, green: 51, blue: 51)
    static let color68 = UIColor.rgb(red: 68, green: 68, blue: 68)
    static let color102 = UIColor.rgb(red: 102, green: 102, blue: 102)
    static let color118 = UIColor.rgb(red: 118, green: 118, blue: 118)
    static let color153 = UIColor.rgb(red: 153, green: 153, blue: 153)
    static let color172 = UIColor.rgb(red: 172, green: 172, blue: 172)
    static let color212 = UIColor.rgb(red: 212, green: 212, blue: 212)
    static let color221 = UIColor.rgb(red: 221, green: 221, blue: 221)
    static let color234 = UIColor.rgb(red: 234, green: 234, blue: 234)
    static let color242 = UIColor.rgb(red: 242, green: 242, blue: 242)
}

// MARK: - UIFont

extension UIFont {
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
