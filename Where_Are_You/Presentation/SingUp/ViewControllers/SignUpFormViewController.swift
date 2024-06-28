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
        self.view = signUpView
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    func buttonActions() {
        signUpView.bottomButtonView.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        signUpView.userIDCheckButton.addTarget(self, action: #selector(duplicateCheckButtonTapped), for: .touchUpInside)
        signUpView.emailCheckButton.addTarget(self, action: #selector(authRequestButtonTapped), for: .touchUpInside)
        signUpView.authCheckButton.addTarget(self, action: #selector(authCheckButtonTapped), for: .touchUpInside)
        
        // 텍스트 필드 변경 감지
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signUpView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupViewModel() {
        let apiService = APIService()
        let userRepository = UserRepository(apiService: apiService)
        let signUpUseCase = SignUpUseCaseImpl(userRepository: userRepository)
        let checkUserIDAvailabilityUseCase = CheckUserIDAvailabilityUseCaseImpl(userRepository: userRepository)
        let checkEmailAvailabilityUseCase = CheckEmailAvailabilityUseCaseImpl(userRepository: userRepository)
        let sendEmailVerificationCodeUseCase = SendEmailVerificationCodeUseCaseImpl(userRepository: userRepository)
        let verifyEmailCodeUseCase = VerifyEmailCodeUseCaseImpl(repository: userRepository)
        
        viewModel = SignUpViewModel(
            signUpUseCase: signUpUseCase,
            checkUserIDAvailabilityUseCase: checkUserIDAvailabilityUseCase,
            checkEmailAvailabilityUseCase: checkEmailAvailabilityUseCase,
            sendEmailVerificationCodeUseCase: sendEmailVerificationCodeUseCase,
            verifyEmailCodeUseCase: verifyEmailCodeUseCase
        )
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
                self?.showAlert(title: "회원가입 실패", message: message)
            }
        }
        
        // 아이디 중복 확인 결과 처리
        viewModel.onUserIDAvailabilityChecked = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.signUpView.userIDErrorLabel.text = message
                self?.signUpView.userIDErrorLabel.textColor = isAvailable ? .brandColor : .warningColor
                if isAvailable {
                    self?.viewModel.user.userId = self?.signUpView.userIDTextField.text
                }
            }
        }
        
        // 비밀번호 형식 오류 처리
        viewModel.onPasswordFormatError = { [weak self] message in
            DispatchQueue.main.async {
                self?.signUpView.passwordErrorLabel.text = message
                self?.signUpView.passwordErrorLabel.textColor = message == "사용가능한 비밀번호입니다." ? .brandColor : .warningColor
                self?.signUpView.passwordTextField.layer.borderColor = message == "사용가능한 비밀번호입니다." ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
            }
        }
        
        // 비밀번호 일치 오류 처리
        viewModel.onCheckPasswordFormatError = { [weak self] message in
            DispatchQueue.main.async {
                self?.signUpView.checkPasswordErrorLabel.text = message
                self?.signUpView.checkPasswordErrorLabel.textColor = message == "비밀번호가 일치힙니다." ? .brandColor : .warningColor
                self?.signUpView.checkPasswordTextField.layer.borderColor = message == "비밀번호가 일치힙니다." ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
            }
        }
        
        // 이메일 형식 확인 + 인증 코드 발송 결과 처리
        viewModel.onEmailVerificationCodeSent = { [weak self] message in
            DispatchQueue.main.async {
                self?.signUpView.emailErrorLabel.text = message
                self?.signUpView.emailErrorLabel.textColor = message == "인증코드가 전송되었습니다." ? .brandColor : .warningColor
                self?.signUpView.authStack.isHidden = message != "인증코드가 전송되었습니다."
            }
        }
        
        // 이메일 인증 코드 확인 결과 처리
        viewModel.onEmailVerificationCodeVerified = { [weak self] message in
            DispatchQueue.main.async {
                self?.signUpView.authCodeErrorLabel.text = message
                self?.signUpView.authCodeErrorLabel.textColor = message == "인증코드가 확인되었습니다." ? .brandColor : .warningColor
                self?.signUpView.authCodeTextField.layer.borderColor = message == "인증코드가 확인되었습니다." ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
            }
        }
        
        // 타이머 업데이트 처리 - 수정된 부분
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.signUpView.timer.text = timeString
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let pw = signUpView.passwordTextField.text else { return }
        guard let checkpw = signUpView.checkPasswordTextField.text else { return }
        
        switch textField {
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
        print("시작하기 눌림")
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
