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
    static func createNavigationBar(for viewController: UIViewController, title: String, backButtonAction: Selector? = nil, showBackButton: Bool = true, rightButton: UIBarButtonItem? = nil) {
        // 네비게이션 바의 외형을 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // 네비게이션 컨트롤러가 존재할 경우 설정 적용
        if let navigationController = viewController.navigationController {
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.tintColor = .white
        }
        
        // 뒤로 가기 버튼을 설정
        if showBackButton, let backButtonAction = backButtonAction {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                             style: .plain,
                                             target: viewController,
                                             action: backButtonAction)
            backButton.tintColor = .blackAC
            viewController.navigationItem.leftBarButtonItem = backButton
        }
        
        if rightButton != nil {
            viewController.navigationItem.rightBarButtonItem = rightButton
        }
        
        let titleLabel = UILabel()
        titleLabel.attributedText = UIFont.CustomFont.bodyP2(text: title, textColor: .black22) // 원하는 텍스트 색상 적용
        titleLabel.sizeToFit()
        viewController.navigationItem.titleView = titleLabel
    }
    
    // TextField with placeholder
    static func textField(withPlaceholder placeholder: String, fontSize: CGFloat) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black22
        tf.adjustsFontForContentSizeCategory = true
        tf.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: fontSize))
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black66])
        return tf
    }
    
    // 두개의 label이 들어간 하나의 버튼
    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        // CustomFont 사용
        let firstAttributedString = UIFont.CustomFont.bodyP4(text: firstPart, textColor: .blackAC)
        let secondAttributedString = UIFont.CustomFont.bodyP4(text: secondPart, textColor: .black66)
        
        // NSAttributedString을 NSMutableAttributedString으로 변환 후 조합
        let attributedTitle = NSMutableAttributedString(attributedString: firstAttributedString)
        attributedTitle.append(NSAttributedString(attributedString: secondAttributedString))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }
}
