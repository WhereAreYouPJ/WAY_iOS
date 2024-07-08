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
    static func createNavigationBar(for viewController: UIViewController, title: String, backButtonAction: Selector? = nil, showBackButton: Bool = true) {
        // 네비게이션 바의 외형을 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // 네비게이션 컨트롤러가 존재할 경우 설정 적용
        if let navigationController = viewController.navigationController {
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.tintColor = .white
        }
        
        // 뒤로 가기 버튼을 설정
        if showBackButton, let backButtonAction = backButtonAction {
            let image = UIImage(systemName: "arrow.backward")
            let backButton = UIBarButtonItem(image: image, style: .plain, target: viewController, action: backButtonAction)
            backButton.tintColor = .color172
            viewController.navigationItem.leftBarButtonItem = backButton
        }
        viewController.navigationItem.title = title
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

// MARK: - ValidationHelper

class ValidationHelper {
    static func isValidUserID(_ userID: String) -> Bool {
        let idRegex = "^[a-z][a-z0-9]{4,11}$"
        let userIDPred = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return userIDPred.evaluate(with: userID)
    }

    static func isValidPassword(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z][A-Za-z0-9]{5,19}$"
        let pwPred = NSPredicate(format: "SELF MATCHES %@", pwRegex)
        return pwPred.evaluate(with: pw)
    }

    static func isPasswordSame(_ pw: String, checkpw: String) -> Bool {
        return pw == checkpw
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - TimerHelper
class TimerHelper {
    private var timer: Timer?
    var timerCount: Int = 300
    var onUpdateTimer: ((String) -> Void)?
    var onTimerExpired: (() -> Void)?

    func startTimer() {
        timerCount = 300
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerCount -= 1
            let minutes = self.timerCount / 60
            let seconds = self.timerCount % 60
            let timeString = String(format: "%02d:%02d", minutes, seconds)
            self.onUpdateTimer?(timeString)
            if self.timerCount == 0 {
                self.stopTimer()
                self.onTimerExpired?()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
