//
//  CustomFontStyle.swift
//  Where_Are_You
//
//  Created by juhee on 27.03.25.
//

import SwiftUI

// 폰트 스타일 속성을 정의하는 구조체
struct FontStyle {
    let font: Font
    let fontSize: CGFloat
    let lineHeight: CGFloat
    let letterSpacing: CGFloat
    
    init(
        family: String = "",
        weight: Font.Weight = .regular,
        size: CGFloat = 16,
        lineHeight: CGFloat = 1.2,
        letterSpacing: CGFloat = 0
    ) {
        self.fontSize = size
        if family.isEmpty {
            self.font = .system(size: size, weight: weight)
        } else {
            self.font = .custom(family, size: size)
        }
        self.lineHeight = lineHeight
        self.letterSpacing = size * letterSpacing / 100
    }
}
