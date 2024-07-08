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
    
    init(textPadding: UIEdgeInsets = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)) {
        self.textPadding = textPadding
        super.init(frame: .zero)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        self.textPadding = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)
        super.init(coder: coder)
        setupBorder()
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
    
    private func setupBorder() {
        layer.borderColor = UIColor.color212.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 7.0
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
}
