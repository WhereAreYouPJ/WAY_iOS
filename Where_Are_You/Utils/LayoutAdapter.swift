//
//  LayoutAdapter.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class LayoutAdapter {
    static let shared = LayoutAdapter()
    private let baseWidth: CGFloat = 375.0  // 피그마 기준 너비
    private let baseHeight: CGFloat = 812.0 // 피그마 기준 높이

    var widthRatio: CGFloat {
        return UIScreen.main.bounds.width / baseWidth
    }

    var heightRatio: CGFloat {
        return UIScreen.main.bounds.height / baseHeight
    }

    private init() {}

    func scale(value: CGFloat, basedOnHeight: Bool = true) -> CGFloat {
        return value * (basedOnHeight ? heightRatio : widthRatio)
    }
}
