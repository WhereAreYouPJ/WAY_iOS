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
        buttonActions()
        setupViewModel()
        setupBindings()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        view.addSubview(signUpView)
        signUpView.frame = view.bounds
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    func buttonActions() {
        signUpView.bottomButtonView.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.userIDCheckButton.addTarget(self, action: #selector(duplicateCheckButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
        
        // 텍스트 필드 변경 감지
        signUpView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpView.userIDTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpView.authCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    private func setupViewModel() {
        let apiService = APIService()
        let userRepository = UserRepository(apiService: apiService)
        let signUpUseCase = SignUpUseCaseImpl(userRepository: userRepository)
        let checkUserIDAvailabilityUseCase = CheckUserIDAvailabilityUseCaseImpl(userRepository: userRepository)
        let checkEmailAvailabilityUseCase = CheckEmailAvailabilityUseCaseImpl(userRepository: userRepository)
        let sendEmailVerificationCodeUseCase = SendEmailVerificationCodeUseCaseImpl(userRepository: userRepository)
        viewModel = SignUpViewModel(signUpUseCase: signUpUseCase,
                                    checkUserIDAvailabilityUseCase: checkUserIDAvailabilityUseCase,
                                    checkEmailAvailabilityUseCase: checkEmailAvailabilityUseCase,
                                    sendEmailVerificationCodeUseCase: sendEmailVerificationCodeUseCase)
    }
    
    private func setupBindings() {
        
        // 회원 가입 성공 시 콜백 처리
        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToNextScreen()
            }
        }
        
        // 회원 가입 실패 시 콜백 처리
        viewModel.onSignUpFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "로그인 실패", message: message)
            }
        }
        
        // 아이디 중복 확인 결과 처리
        viewModel.onUserIDAvailabilityChecked = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.signUpView.userIDErrorLabel.text = message
                self?.signUpView.userIDErrorLabel.textColor = isAvailable ? .brandColor : .warningColor
            }
        }
        
        // 이메일 형식 오류 처리
        viewModel.onEmailFormatError = { [weak self] message in
            DispatchQueue.main.async {
                self?.signUpView.emailErrorLabel.text = message
                self?.signUpView.emailErrorLabel.textColor = .warningColor
                self?.signUpView.authStack.isHidden = true
            }
        }
        
        
        
    }
    
    // MARK: - Selectors
    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case signUpView.userNameTextField:
            viewModel.userName = textField.text ?? ""
        case signUpView.userIDTextField:
            viewModel.userID = textField.text ?? ""
        case signUpView.passwordTextField:
            viewModel.password = textField.text ?? ""
        case signUpView.checkPasswordTextField:
            viewModel.confirmPassword = textField.text ?? ""
        case signUpView.emailTextField:
            viewModel.email = textField.text ?? ""
        case signUpView.authCodeTextField:
            viewModel.verificationCode = textField.text ?? ""
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func duplicateCheckButtonTapped() {
        guard let userID = signUpView.userIDTextField.text, !userID.isEmpty else {
            // 아이디가 비어있을 때 알림
            signUpView.userIDErrorLabel.text = "영문 소문자와 숫자만 사용하여, 영문 소문자로 시작하는 5~12자의 아이디를 입력해주세요"
            return
        }
        // 여기에 api 통신 넣기
        viewModel.checkUserIDAvailability()
    }
    
    @objc func authRequestButtonTapped() {
        guard let email = signUpView.emailTextField.text, !email.isEmpty else {
            signUpView.emailErrorLabel.text = "이메일 형식에 알맞지 않습니다."
            return
        }
        // 여기에 signUpView.authCheckStack.isHidden = false로 설정하고 api 넣기
        signUpView.authStack.isHidden = false
        viewModel.checkEmailAvailability()
    }
    
    @objc func authCheckButtonTapped() {
        guard let code = signUpView.authCodeTextField.text, !code.isEmpty else {
            signUpView.authCodeErrorLabel.text = "인증코드가 알맞지 않습니다."
            return
        }
        viewModel.verifyEmailCode(inputCode: code)
    }
    
    @objc func startButtonTapped() {
        viewModel.signUp()
        
    }
    
    private func navigateToNextScreen() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
