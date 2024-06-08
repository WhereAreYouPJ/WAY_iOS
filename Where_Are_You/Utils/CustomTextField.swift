//
//  CustomTextField.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/6/2024.
//

import UIKit

class CustomTextField: UITextField {
    
    var textPadding = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorder()
    }
    
    private func setupBorder() {
        layer.borderColor = UIColor.color212.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 7.0
    }
}
