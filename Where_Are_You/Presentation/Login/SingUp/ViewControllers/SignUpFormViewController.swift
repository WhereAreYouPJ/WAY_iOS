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
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = SignUpViewModel(
            accountSignUpUseCase: AccountSignUpUseCaseImpl(memberRepository: memberRepository),
            checkEmailUseCase: CheckEmailUseCaseImpl(memberRepository: memberRepository),
            emailSendUseCase: EmailSendUseCaseImpl(memberRepository: memberRepository),
            emailVerifyUseCase: EmailVerifyUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupUI() {
        view = signUpView
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupActions() {
        signUpView.bottomButtonView.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
        
        signUpView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signUpView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToNextScreen()
            }
        }
        
        viewModel.onSignUpButtonState = { [weak self] isAvailable in
            DispatchQueue.main.async {
                self?.signUpView.bottomButtonView.button.isEnabled = isAvailable
                self?.signUpView.bottomButtonView.button.backgroundColor = isAvailable ? .brandColor : .color171
            }
        }
        
        viewModel.onUserNameValidationMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.userNameErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.userNameTextField)
            }
        }
        
        viewModel.onPasswordFormatMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.passwordErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.passwordTextField)
            }
        }
        
        viewModel.onCheckPasswordFormatMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.checkPasswordErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.checkPasswordTextField)
            }
        }
        
        viewModel.onEmailSendMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.emailErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.emailTextField)
                self?.signUpView.authStack.isHidden = !isAvailable
                if isAvailable == true {
                    self?.signUpView.emailCheckButton.updateTitle("인증요청 완료")
                    self?.signUpView.emailCheckButton.updateBackgroundColor(.color171)
                    self?.signUpView.emailCheckButton.isEnabled = isAvailable
                }
            }
        }
        
        viewModel.onEmailVerifyCodeMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.authCodeErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.authCodeTextField)
                if isAvailable == true {
                    self?.signUpView.authCheckButton.updateTitle("인증 완료")
                    self?.signUpView.authCheckButton.updateBackgroundColor(.color171)
                    self?.signUpView.authCheckButton.isEnabled = isAvailable
                }
            }
        }
        
        // 타이머 업데이트
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
            viewModel.checkUserNameValidation(userName: userName)
        case signUpView.passwordTextField:
            viewModel.checkPasswordAvailability(password: pw)
        case signUpView.checkPasswordTextField:
            viewModel.checkSamePassword(password: pw, checkPassword: checkpw)
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
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
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.text = message
        label?.textColor = isAvailable ? .brandColor : .warningColor
        textField?.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
    }
}
