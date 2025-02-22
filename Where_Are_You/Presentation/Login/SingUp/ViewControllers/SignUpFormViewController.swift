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
    var type: [String] = []
    
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
        signUpView.bottomButtonView.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
        
        signUpView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
                self?.signUpView.bottomButtonView.isEnabled = isAvailable
                self?.signUpView.bottomButtonView.backgroundColor = isAvailable ? .brandMain : .blackAC
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
                self?.signUpView.emailCheckButton.hideLoading()
                self?.signUpView.authStack.isHidden = !isAvailable
                self?.signUpView.emailCheckButton.isEnabled = !isAvailable
                self?.signUpView.emailCheckButton.updateBackgroundColor(isAvailable ? .color171 : .brandMain)
            }
        }
        
        viewModel.onCheckEmailDuplicate = { [weak self] type in
            self?.type = type
        }
        
        viewModel.onEmailVerifyCodeMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.signUpView.authCodeErrorLabel, message: message, isAvailable: isAvailable, textField: self?.signUpView.authCodeTextField)
                if isAvailable == true {
                    self?.signUpView.authCheckButton.updateTitle("인증 완료")
                    self?.signUpView.authCheckButton.updateBackgroundColor(.color171)
                    self?.signUpView.authCodeTextField.backgroundColor = .blackF0
                    self?.signUpView.authCodeTextField.isEnabled = !isAvailable
                    self?.signUpView.authCheckButton.isEnabled = !isAvailable
                    self?.signUpView.timer.attributedText = UIFont.CustomFont.bodyP4(text: "", textColor: .error)
                }
            }
        }
        
        // 타이머 업데이트
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.signUpView.timer.attributedText = UIFont.CustomFont.bodyP4(text: timeString, textColor: .error)
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
        case signUpView.emailTextField:
            resetAuthUI()
        case signUpView.passwordTextField:
            viewModel.checkPasswordAvailability(password: pw)
            viewModel.checkSamePassword(password: pw, checkPassword: checkpw)
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
        signUpView.emailCheckButton.showLoading()
        viewModel.checkEmailAvailability(email: signUpView.emailTextField.text ?? "")
    }
    
    @objc func authCheckButtonTapped() {
        viewModel.verifyEmailCode(inputCode: signUpView.authCodeTextField.text ?? "")
    }
    
    @objc func startButtonTapped() {
        if type.isEmpty {
            viewModel.signUp()
        } else {
            let email = viewModel.email
            guard let password = viewModel.signUpBody.password, let userName = viewModel.signUpBody.userName else { return }
            let controller = SocialLinkViewController(email: email, password: password, userName: userName, loginType: "normal", linkLoginType: type)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Helpers
    
    private func navigateToNextScreen() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func resetAuthUI() {
        signUpView.emailCheckButton.updateBackgroundColor(.brandMain)
        signUpView.emailCheckButton.isEnabled = true
        
        signUpView.authCheckButton.updateBackgroundColor(.brandMain)
        signUpView.authCheckButton.isEnabled = true
        signUpView.authCheckButton.updateTitle("확인")
        
        signUpView.authCodeTextField.setupTextField(placeholder: "인증코드 입력")
        signUpView.authCodeTextField.backgroundColor = .white
        signUpView.authCodeTextField.isEnabled = true
        signUpView.authCodeTextField.attributedText = nil
        
        signUpView.authCodeErrorLabel.attributedText = UIFont.CustomFont.bodyP5(text: "", textColor: .brandMain)
        
        signUpView.authStack.isHidden = true

        viewModel.signUpBody.email = nil
    }
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.attributedText = UIFont.CustomFont.bodyP5(text: message, textColor: isAvailable ? .brandMain : .error)
        if let customTF = textField as? CustomTextField {
            // 조건이 맞지 않으면 error 상태를 유지하도록 설정
            customTF.setErrorState(!isAvailable)
        }
    }
}
