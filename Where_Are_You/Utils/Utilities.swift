//
//  Utilities.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class Utilities {
    
    func fontLabel(fontStyle: UIFont.Weight, text: String, size: CGFloat) -> UILabel {
        switch fontStyle {
        case .medium:
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "NotoSansKR-Medium", size: size)
            return label
        case .bold:
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "NotoSansKR-Bold", size: size)
            return label
        default:
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "NotoSansKR-Medium", size: size)
            return label
        }
    }
    
    func inputContainerButton(withImage image: String, title: String, backgroundColor: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont.pretendard(size: 14, weight: .medium)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.mentionTextColor])
        return tf
    }
}
