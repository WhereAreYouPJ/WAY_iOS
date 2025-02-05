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
    
    init(textPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: LayoutAdapter.shared.scale(value: 12), bottom: 0, right: LayoutAdapter.shared.scale(value: 12)),
         placeholder: String,
         hasBorder: Bool = true) {
        self.textPadding = textPadding
        self.hasBorder = hasBorder
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        self.textPadding = UIEdgeInsets(top: 0, left: LayoutAdapter.shared.scale(value: 12), bottom: 0, right: LayoutAdapter.shared.scale(value: 12))
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
    
    // MARK: - 포커스 상태에 따른 border 색상 변경
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result && hasBorder {
            // 텍스트 필드가 포커스를 받으면 border 색상을 brandMain 컬러로 변경
            layer.borderColor = UIColor.brandMain.cgColor
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result && hasBorder {
            // 텍스트 필드의 포커스가 해제되면 border 색상을 기본인 blackD4 컬러로 변경
            layer.borderColor = UIColor.blackD4.cgColor
        }
        return result
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: LayoutAdapter.shared.scale(value: 44))
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
