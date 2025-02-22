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
    private var errorState: Bool = false
    
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
    
    func setupTextField(placeholder: String?) {
        adjustsFontForContentSizeCategory = true
        font = UIFont(name: "Pretendard-Medium", size: 16)

        // Set placeholder with color
        if let placeholderText = placeholder {
            attributedPlaceholder = UIFont.CustomFont.bodyP3(text: placeholderText, textColor: .black66)
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
    
    // MARK: - 에러 상태 업데이트 메서드
    /// 외부에서 조건에 따라 에러 상태를 설정하거나 해제할 때 호출
    func setErrorState(_ isError: Bool) {
        self.errorState = isError
        if isError {
            // 에러인 경우 즉시 border 색상을 error 색상으로 변경
            layer.borderColor = UIColor.error.cgColor
        } else {
            // 에러가 해제되면 현재 포커스 상태에 따라 색상 업데이트
            if isFirstResponder {
                layer.borderColor = UIColor.brandMain.cgColor
            } else {
                layer.borderColor = UIColor.blackD4.cgColor
            }
        }
    }
    
    // MARK: - 포커스 상태에 따른 border 색상 변경 (에러 상태 고려)
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result && hasBorder {
            // 에러 상태가 아니라면 포커스 시 brandMain, 에러 상태면 그대로 error 색상 유지
            if !errorState {
                layer.borderColor = UIColor.brandMain.cgColor
            }
        }
        // 포커스를 받은 후 전체 선택을 해제하고 커서를 텍스트 끝으로 이동
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let currentText = self.text, !currentText.isEmpty else { return }
            let endPosition = self.endOfDocument
            self.selectedTextRange = self.textRange(from: endPosition, to: endPosition)
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result && hasBorder {
            // 에러 상태이면 error 색상, 아니라면 기본 색상으로 변경
            if errorState {
                layer.borderColor = UIColor.error.cgColor
            } else {
                layer.borderColor = UIColor.blackD4.cgColor
            }
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
