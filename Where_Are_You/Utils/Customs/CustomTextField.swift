//
//  CustomTextField.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

// MARK: - CustomTextField

class CustomTextField: UITextField {
    
    private var textPadding: UIEdgeInsets
    private var placeholderText: String?
    private var hasBorder: Bool
    
    init(textPadding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8),
         placeholder: String,
         hasBorder: Bool = true,
         fontSize: CGFloat = LayoutAdapter.shared.scale(value: 14)) {
        self.textPadding = textPadding
        self.hasBorder = hasBorder
        self.placeholderText = placeholder
        super.init(frame: .zero)
        setupTextField()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        self.textPadding = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        self.hasBorder = true
        super.init(coder: coder)
        setupTextField()
        setupBorder()
    }
    
    private func setupTextField() {
        adjustsFontForContentSizeCategory = true
        textColor = .black22
        font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14)))
        
        // Set placeholder with color
        if let placeholderText = placeholderText {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black66])
        }
    }
    
    private func setupBorder() {
        if hasBorder {
            layer.borderColor = UIColor.color212.cgColor
            layer.borderWidth = 1.0
            layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        } else {
            layer.borderWidth = 0
        }
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
