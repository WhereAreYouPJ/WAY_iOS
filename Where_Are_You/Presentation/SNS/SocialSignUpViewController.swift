//
//  SocialSignUpViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/2/2025.
//

import UIKit

class SocialSignUpViewController: UIViewController {
    // MARK: - Properties
    let socialSignUpView = SocialSignUpView()
    private var viewModel: SocialSignUpViewModel!
    
    var email: String = ""
    private var userIdentifier: String = ""
    private var userName: String = ""
    private var loginType: String = ""
    private var linkLoginType: [String] = []
    
    // MARK: - Lifecycle
    init(email: String, userIdentifier: String, userName: String, loginType: String) {
        super.init(nibName: nil, bundle: nil)
        self.email = email
        self.userIdentifier = userIdentifier
        self.userName = userName
        self.loginType = loginType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view = socialSignUpView
        socialSignUpView.userNameTextField.attributedText = UIFont.CustomFont.bodyP3(text: userName, textColor: .black22)
        socialSignUpView.emailTextField.setupTextField(placeholder: email)
        socialSignUpView.emailTextField.isEnabled = false
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = SocialSignUpViewModel(
            snsSignUpUseCase: SnsSignUpUseCaseImpl(memberRepository: memberRepository),
            checkEmailUseCase: CheckEmailUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.moveToSignUpSuccess()
            }
        }
        
        viewModel.onEmailDuplicate = { [weak self] linkLoginType in
            DispatchQueue.main.async {
                self?.linkLoginType = linkLoginType
                self?.moveToSocialLink()
            }
        }
        
        viewModel.onUserNameValidationMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.socialSignUpView.userNameErrorLabel, message: message, isAvailable: isAvailable, textField: self?.socialSignUpView.userNameTextField)
                self?.socialSignUpView.bottomButtonView.isEnabled = isAvailable
                self?.socialSignUpView.bottomButtonView.backgroundColor = isAvailable ? .brandMain : .blackAC
            }
        }
    }
    
    private func setupActions() {
        socialSignUpView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        socialSignUpView.bottomButtonView.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    private func moveToSocialLink() {
        // 소셜 연동 뷰로 이동
        guard let userName = socialSignUpView.userNameTextField.text else { return }
        let controller = SocialLinkViewController(email: email, password: userIdentifier, userName: userName, loginType: loginType, linkLoginType: linkLoginType)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func moveToSignUpSuccess() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.attributedText = UIFont.CustomFont.bodyP5(text: message, textColor: isAvailable ? .brandMain : .error)
        if let customTF = textField as? CustomTextField {
            // 조건이 맞지 않으면 error 상태를 유지하도록 설정
            customTF.setErrorState(!isAvailable)
        }
    }
    
    // MARK: - Selectors
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let userName = socialSignUpView.userNameTextField.text else { return }
        viewModel.checkUserNameValidation(userName: userName)
    }
    
    @objc private func signupButtonTapped() {
        viewModel.checkEmailAvailability(userName: userName, email: email, password: userIdentifier, loginType: loginType)
    }
    
    @objc private func backButtonTapped() {
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
