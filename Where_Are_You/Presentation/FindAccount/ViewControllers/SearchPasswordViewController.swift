//
//  SearchPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class SearchPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    let searchPasswordView = SearchAuthView()
    private var viewModel: PasswordResetViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchPasswordView
        
        setupUI()
        configureNavigationBar(title: "비밀번호 찾기", backButtonAction: #selector(backButtonTapped))
        buttonActions()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        searchPasswordView.emailLabel.label.text = "아이디"
        searchPasswordView.emailTextField.placeholder = "아이디"
    }
    
    func setupViewModel() {
        let apiService = APIService()
        let userRepository = UserRepository(apiService: apiService)
        let sendEmailVerificationCodeUseCase = SendEmailVerificationCodeUseCaseImpl(userRepository: userRepository)
        let verifyEmailCodeUseCase = VerifyEmailCodeUseCaseImpl(userRepository: userRepository)
        
        viewModel = PasswordResetViewModel(
            sendEmailVerificationCodeUseCase: sendEmailVerificationCodeUseCase,
            verifyEmailCodeUseCase: verifyEmailCodeUseCase)
    }
    
    func buttonActions() {
        searchPasswordView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        let controller = ResetPasswordViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
}
