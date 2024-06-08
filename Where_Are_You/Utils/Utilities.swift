//
//  Utilities.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

let textFieldFontSize: CGFloat = 14
let descriptionFontSize: CGFloat = 12

class Utilities {
    
    // 네비게이션 바 생성
    static func createNavigationBar(for viewController: UIViewController, title: String, backButtonAction: Selector?, showBackButton: Bool = true) {
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
    
    // 레이블 생성
    func createLabel(NotoSans weight: UIFont.Weight, text: String, textColor: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: weight, fontSize: fontSize))
        return label
    }
    
    // TextField with layer and placeholder
    func inputContainerTextField(withPlaceholder placeholder: String, fontSize: CGFloat) -> CustomTextField {
        let tf = CustomTextField()
        tf.adjustsFontForContentSizeCategory = true
        tf.textColor = .color34
        tf.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: fontSize))
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.color102])
        return tf
    }
    
    // TextField with placeholder
    func textField(withPlaceholder placeholder: String, fontSize: CGFloat) -> UITextField {
        let tf = UITextField()
        tf.textColor = .color34
        tf.adjustsFontForContentSizeCategory = true
        tf.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: fontSize))
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.color102])
        return tf
    }
    
    // 두개의 label이 들어간 하나의 버튼
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14)), NSAttributedString.Key.foregroundColor: UIColor.color153])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14)), NSAttributedString.Key.foregroundColor: UIColor.color102]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }
}
