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
    init(UIFont text: NSAttributedString) {
        super.init(frame: .zero)
        
        self.attributedText = text
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
