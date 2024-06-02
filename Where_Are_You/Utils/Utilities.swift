//
//  Utilities.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class Utilities {
    // 네비게이션 바 생성
    static func configureNavigationBar(for viewController: UIViewController, title: String, backButtonAction: Selector?, showBackButton: Bool = true) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if let navigationController = viewController.navigationController {
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.tintColor = .white
        }
        
        if showBackButton, let backButtonAction = backButtonAction {
            let image = UIImage(systemName: "arrow.backward")
            let backButton = UIBarButtonItem(image: image, style: .plain, target: viewController, action: backButtonAction)
            backButton.tintColor = .color172
            viewController.navigationItem.leftBarButtonItem = backButton
        }
        
        viewController.navigationItem.title = title
    }
    
    // 스택뷰 생성
    func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }
    
    // paddingLabel (left 4,bottom 6)
    func inputContainerLabel(UILabel_NotoSans weight: UIFont.Weight, text: String, textColor: UIColor, fontSize: CGFloat) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.pretendard(NotoSans: weight, fontSize: fontSize)
        label.numberOfLines = 0
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
    
    // TextField with layer and placeholder
    func inputContainerTextField(withPlaceholder placeholder: String, fontSize: CGFloat) -> UITextField {
        let tf = UITextField()
        tf.textColor = .color34
        tf.font = UIFont.pretendard(NotoSans: .medium, fontSize: fontSize)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.color102])
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = UIColor.color212.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: tf.frame.height))
        tf.leftView = paddingView
        tf.rightView = paddingView
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        return tf
    }
    
    // TextField with placeholder
    func textField(withPlaceholder placeholder: String, fontSize: CGFloat) -> UITextField {
        let tf = UITextField()
        tf.textColor = .color34
        tf.font = UIFont.pretendard(NotoSans: .medium, fontSize: fontSize)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.color102])
        return tf
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
