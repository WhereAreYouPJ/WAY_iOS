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
    
    let searchPasswordView = AccountSearchView()
    private var viewModel: UserIdEmailVerificaitonViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchPasswordView
        
        setupUI()
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        searchPasswordView.emailLabel.text = "아이디"
        searchPasswordView.emailTextField.placeholder = "아이디"
        configureNavigationBar(title: "비밀번호 찾기", backButtonAction: #selector(backButtonTapped))
    }
    
    func setupViewModel() {
        let authService = AuthService()
        let authRepository = AuthRepository(authService: authService)
        viewModel = UserIdEmailVerificaitonViewModel(
            sendVerificationCodeUseCase: SendVerificationCodeUseCaseImpl(authRepository: authRepository),
            verifyCodeUseCase: VerifyCodeUseCaseImpl(authRepository: authRepository))
    }
    
    func setupBindings() {
        // 인증코드 전송 결과
        viewModel.onRequestCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchPasswordView.emailErrorLabel.text = message
                self?.searchPasswordView.emailErrorLabel.textColor = .brandColor
                self?.searchPasswordView.authStack.isHidden = false
            }
        }
        
        viewModel.onRequestCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchPasswordView.emailErrorLabel.text = message
                self?.searchPasswordView.emailErrorLabel.textColor = .warningColor
                self?.searchPasswordView.authStack.isHidden = true
            }
        }
        
        // 인증코드 결과
        viewModel.onVerifyCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchPasswordView.authNumberErrorLabel.text = message
                self?.searchPasswordView.authNumberErrorLabel.textColor = .brandColor
            }
        }
        
        viewModel.onVerifyCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchPasswordView.authNumberErrorLabel.text = message
                self?.searchPasswordView.authNumberErrorLabel.textColor = .warningColor
            }
        }
        
        // 다음화면으로 넘어가기 버튼
        viewModel.onVerifySuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToResetPassword()
            }
        }
        
        viewModel.onVerifyFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "인증 실패", message: message)
            }
        }
        
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.searchPasswordView.timer.text = timeString
            }
        }
    }
    
    func setupActions() {
        searchPasswordView.requestAuthButton.addTarget(self, action: #selector(requestAuth), for: .touchUpInside)
        searchPasswordView.authNumberCheckButton.addTarget(self, action: #selector(authCodeCheck), for: .touchUpInside)
        searchPasswordView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func requestAuth() {
        guard let userId = searchPasswordView.emailTextField.text else { return }
        viewModel.sendEmailVerificationCode(userId: userId)
    }
    
    @objc func authCodeCheck() {
        guard let code = searchPasswordView.authNumberTextField.text else { return }
        viewModel.verifyEmailCode(code: code)
    }
    
    @objc func confirmButtonTapped() {
        viewModel.moveToReset()
    }
    
    private func navigateToResetPassword() {
        let controller = ResetPasswordViewController()
        controller.userId = viewModel.userId
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
