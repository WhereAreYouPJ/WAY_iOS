//
//  Custom1.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

// MARK: - CustomLabel
class StandardLabel: UILabel {
    private var textInsets = UIEdgeInsets.zero

    init(UIFont text: NSAttributedString, isPaddingLabel: Bool = false) {
        super.init(frame: .zero)
        
        self.attributedText = text
        self.numberOfLines = 0
        if isPaddingLabel {
            textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        // 텍스트를 insets만큼 줄인 영역에서 그립니다.
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // 실제 텍스트가 차지할 영역을 계산한 뒤
        let insetBounds = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        // 원래 좌표계로 복귀시키기 위해 반대 방향으로 offset
        return CGRect(
            x: textInsets.left + textRect.origin.x,
            y: textInsets.top + textRect.origin.y,
            width: textRect.width,
            height: textRect.height
        )
    }
    
    func updateText(_ text: NSAttributedString) {
        self.attributedText = text
    }
    
    func updateTextKeepingAttributes(newText: String) {
        if let mutableAttrText = self.attributedText?.mutableCopy() as? NSMutableAttributedString {
            mutableAttrText.mutableString.setString(newText)
            self.attributedText = mutableAttrText
        } else {
            self.text = newText
        }
    }
}

// inputContainerLabel
class CustomLabel: UILabel {
    private let inset: UIEdgeInsets
    
    init(UILabel_NotoSans weight: UIFont.Weight, text: String, textColor: UIColor, fontSize: CGFloat, inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)) {
        self.inset = inset
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = textColor
        self.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: weight, fontSize: fontSize))
        self.adjustsFontForContentSizeCategory = true
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + inset.left + inset.right, height: size.height + inset.top + inset.bottom)
    }
}
