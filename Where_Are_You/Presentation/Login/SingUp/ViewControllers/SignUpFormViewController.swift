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
    private var viewModel: SignUpViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupViewModel()
        setupBindings()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        view = signUpView
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    func setupActions() {
        signUpView.bottomButtonView.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.userIDCheckButton.addTarget(self, action: #selector(duplicateCheckButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
        
        signUpView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signUpView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupViewModel() {
        let authService = AuthService()
        let authRepository = AuthRepository(authService: authService)
        viewModel = SignUpViewModel(
            signUpUseCase: SignUpUseCaseImpl(authRepository: authRepository),
            checkUserIDAvailabilityUseCase: CheckUserIDAvailabilityUseCaseImpl(authRepository: authRepository),
            checkEmailAvailabilityUseCase: CheckEmailAvailabilityUseCaseImpl(authRepository: authRepository),
            sendVerificationCodeUseCase: SendVerificationCodeUseCaseImpl(authRepository: authRepository),
            verifyCodeUseCase: VerifyCodeUseCaseImpl(authRepository: authRepository)
        )
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToNextScreen()
            }
        }
        
        viewModel.onSignUpFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "회원가입 실패", message: message)
            }
        }
        
        viewModel.onUserIDAvailabilityChecked = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.userIDErrorLabel, message: message, isAvailable: isAvailable, textField: nil)
            }
        }
        
        viewModel.onPasswordFormatError = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.passwordErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.passwordTextField)
            }
        }
        
        viewModel.onCheckPasswordFormatError = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.checkPasswordErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.checkPasswordTextField)
            }
        }
        
        viewModel.onEmailVerificationCodeSent = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.emailErrorLabel, message: message, isAvailable: isAvailable, textField: nil)
                self?.signUpView.authStack.isHidden = !isAvailable
            }
        }
        
        viewModel.onEmailVerificationCodeVerified = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.authCodeErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.authCodeTextField)
            }
        }
        
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.signUpView.timer.text = timeString
            }
        }
    }
    // MARK: - Selectors
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let userName = signUpView.userNameTextField.text,
              let pw = signUpView.passwordTextField.text,
              let checkpw = signUpView.checkPasswordTextField.text else { return }
        
        switch textField {
        case signUpView.userNameTextField:
            viewModel.authCredentials.userName = userName
        case signUpView.passwordTextField:
            viewModel.password = pw
            viewModel.checkPasswordAvailability(password: pw)
        case signUpView.checkPasswordTextField:
            viewModel.confirmPassword = checkpw
            viewModel.checkSamePassword(password: pw, checkPassword: checkpw)
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func duplicateCheckButtonTapped() {
        viewModel.checkUserIDAvailability(userId: signUpView.userIDTextField.text ?? "")
    }
    
    @objc func authRequestButtonTapped() {
        viewModel.checkEmailAvailability(email: signUpView.emailTextField.text ?? "")
    }
    
    @objc func authCheckButtonTapped() {
        viewModel.verifyEmailCode(inputCode: signUpView.authCodeTextField.text ?? "")
    }
    
    @objc func startButtonTapped() {
        viewModel.signUp()
    }
    
    // MARK: - Helpers
    
    private func navigateToNextScreen() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.text = message
        label?.textColor = isAvailable ? .brandColor : .warningColor
        textField?.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
    }
}
