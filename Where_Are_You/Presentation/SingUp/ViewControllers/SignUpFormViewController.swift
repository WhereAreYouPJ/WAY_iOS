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
        setupBindings()
        setupViewModel()
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
        viewModel.onUserIDAvailabilityChecked = { [weak self] message in
            if message {
                self?.signUpView.userIDErrorLabel.text = "사용가능한 아이디입니다."
            } else {
                self?.signUpView.userIDErrorLabel.text = "중복된 아이디입니다."
            }
        }
    }
    
    // MARK: - Selectors
    
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
            signUpView.emailErrorLabel.text = "이메일 형식에 맞지 않습니다."
            return
        }
        // 여기에 signUpView.authCheckStack.isHidden = false로 설정하고 api 넣기
        signUpView.authStack.isHidden = false
        viewModel.checkEmailAvailability()
    }
    
    @objc func authCheckButtonTapped() {
        guard let code = signUpView.authCodeTextField.text, !code.isEmpty else {
            signUpView.authCodeErrorLabel.text = ""
            return
        }
    }
    
    @objc func startButtonTapped() {
        viewModel.signUp()
        let controller = FinishRegisterViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}
