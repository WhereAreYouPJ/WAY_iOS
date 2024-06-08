//
//  SignUpFormViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit

class SignUpFormViewController: UIViewController {
    // MARK: - Properties
    
    let signUpView = SignUpFormView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUpView)
        signUpView.frame = view.bounds
        
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
        buttonActions()
    }
    
    // MARK: - Helpers
    
    func buttonActions() {
        signUpView.bottomButtonView.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.userIDCheckButton.addTarget(self, action: #selector(duplicateCheckButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func duplicateCheckButtonTapped() {
        guard let userID = signUpView.userIDTextField.text, !userID.isEmpty else {
                // 아이디가 비어있을 때 알림
            signUpView.userIDErrorLabel.text = "아이디를 입력해주세요."
                return
            }
            // 여기에 api 통신 넣기
        }
    
    @objc func authRequestButtonTapped() {
        guard let email = signUpView.emailTextField.text, !email.isEmpty else {
            signUpView.emailErrorLabel.text = "이메일을 입력해주세요."
            return
        }
        // 여기에 signUpView.authCheckStack.isHidden = false로 설정하고 api 넣기
        signUpView.authStack.isHidden = false
    }
    
    @objc func authCheckButtonTapped() {
        
    }
    
    @objc func startButtonTapped() {
        let controller = FinishRegisterViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}
