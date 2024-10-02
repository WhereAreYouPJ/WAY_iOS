//
//  AccountLoginController.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class AccountLoginController: UIViewController {
    // MARK: - Properties
    let accountLoginView = AccountLoginView()
    private var viewModel: AccountLoginViewModel!
    
    private var userEmailEnter: Bool = false
    private var passwordEnter: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupViewModel()
        setupBindings()
    }
    
    // MARK: - Helpers
   private func setupUI() {
        self.view = accountLoginView
        configureNavigationBar(title: "로그인", backButtonAction: #selector(backButtonTapped))
        accountLoginView.passwordTextField.isSecureTextEntry = true
    }
    
    private func setupActions() {
        accountLoginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        accountLoginView.findAccountButton.button.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        accountLoginView.signupButton.addTarget(self, action: #selector(registerAccountButtonTapped), for: .touchUpInside)
        
        accountLoginView.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        accountLoginView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = AccountLoginViewModel(accountLoginUseCase: AccountLoginUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            let controller = MainTabBarController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
        
        // 로그인 실패
        viewModel.onLoginFailure = { [weak self] message, isAvailable in
            // 로그인 실패
            self?.updateStatus(label: self?.accountLoginView.emailErrorLabel,
                               message: message,
                               isAvailable: isAvailable,
                               textField: self?.accountLoginView.emailTextField)
        }
    }
    
    // MARK: - Selectors
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // viewmodel에 로그인하기 버튼 활성화 비활성화 로직 추가하기
    @objc private func textFieldDidChange(_ textField: UITextField) {
        accountLoginView.updateLoginButtonState()
    }
    
    @objc private func loginButtonTapped() {
        guard let email = accountLoginView.emailTextField.text, !email.isEmpty,
              let password = accountLoginView.passwordTextField.text, !password.isEmpty else { return }
        
        viewModel.login(email: email, password: password)
    }
    
    @objc private func findAccountButtonTapped() {
        let controller = AccountSearchViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func registerAccountButtonTapped() {
        let controller = TermsAgreementViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.text = message
        label?.textColor = isAvailable ? .brandColor : .warningColor
        textField?.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
    }
}
