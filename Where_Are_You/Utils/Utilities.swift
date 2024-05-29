//
//  Utilities.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class Utilities {
    
    // 스택뷰 생성
    func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }
    
    // button이 들어간 뷰
    func inputContainerView(button: UIButton) -> UIView {
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(view).offset(6)
            make.bottom.equalTo(view).offset(-4)
        }
        return view
    }
    
    // label이 들어간 뷰
    func inputContainerView(label: UILabel) -> UIView {
        let view = UIView()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(view).offset(6)
            make.bottom.equalTo(view).offset(-4)
        }
        return view
    }
    
    func createLabel(NotoSans weight: UIFont.Weight, text: String, textColor: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.pretendard(NotoSans: weight, fontSize: fontSize)
        return label
    }
    
    // 텍스트 필드가 들어간 뷰 (left: 8, top: 12)
    func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()
        view.addSubview(textField)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.color212.cgColor
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(view).offset(8)
            make.bottom.equalTo(view).offset(-12)
        }
        return view
    }
    
    // placeholder이 들어간 텍스트 필드
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.color102])
        tf.layer.cornerRadius = 7
        return tf
    }
    
    // 이미지가 들어간 버튼
    func inputContainerButton(withImage image: String, title: String, backgroundColor: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 7
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }
    
    // 두개의 label이 들어간 하나의 버튼
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 14), NSAttributedString.Key.foregroundColor: UIColor.color153])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 14), NSAttributedString.Key.foregroundColor: UIColor.color102]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
