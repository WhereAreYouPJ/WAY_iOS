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
    private var hasBorder: Bool
    
    init(textPadding: UIEdgeInsets = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12),
         placeholder: String,
         hasBorder: Bool = true) {
        self.textPadding = textPadding
        self.hasBorder = hasBorder
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        self.textPadding = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        self.hasBorder = true
        super.init(coder: coder)
        setupTextField(placeholder: nil)
        setupBorder()
    }
    
    private func setupTextField(placeholder: String?) {
        adjustsFontForContentSizeCategory = true
        font = UIFont(name: "Pretendard-Medium", size: 14)
        
        // Set placeholder with color
        if let placeholderText = placeholder {
            attributedPlaceholder = UIFont.CustomFont.bodyP4(text: placeholderText, textColor: .black66)
        }
    }
    
    private func setupBorder() {
        if hasBorder {
            layer.borderColor = UIColor.blackD4.cgColor
            layer.borderWidth = 1.5
            layer.cornerRadius = 8
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
