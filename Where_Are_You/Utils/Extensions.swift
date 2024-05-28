//
//  Extensions.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let brancColor = UIColor.rgb(red: 123, green: 80, blue: 255)
    static let letterBrandColor = UIColor.rgb(red: 98, green: 54, blue: 233)
    static let warningColor = UIColor.rgb(red: 223, green: 67, blue: 67)
    
    static let color34 = UIColor.rgb(red: 34, green: 34, blue: 34)
    static let color51 = UIColor.rgb(red: 51, green: 51, blue: 51)
    static let color68 = UIColor.rgb(red: 68, green: 68, blue: 68)
    static let color102 = UIColor.rgb(red: 102, green: 102, blue: 102)
    static let color153 = UIColor.rgb(red: 153, green: 153, blue: 153)
    static let color212 = UIColor.rgb(red: 212, green: 212, blue: 212)
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
