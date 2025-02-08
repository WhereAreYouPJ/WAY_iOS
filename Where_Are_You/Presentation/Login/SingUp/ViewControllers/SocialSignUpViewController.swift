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
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        viewModel.signUpBody.password = userIdentifier
        viewModel.signUpBody.fcmToken = userName
        viewModel.signUpBody.loginType = loginType

        socialSignUpView.emailTextField.attributedText = UIFont.CustomFont.bodyP3(text: email, textColor: .black66)
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
        
        viewModel.onEmailDuplicate = { [weak self] in
            DispatchQueue.main.async {
                self?.moveToSocialLink()
            }
        }
        
        viewModel.onUserNameValidationMessage = { [weak self] message, isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.socialSignUpView.userNameErrorLabel, message: message, isAvailable: isAvailable, textField: self?.socialSignUpView.userNameTextField)
                self?.socialSignUpView.bottomButtonView.isEnabled = !isAvailable
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
    }
    
    private func moveToSignUpSuccess() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func updateStatus(label: UILabel?, message: String, isAvailable: Bool, textField: UITextField?) {
        label?.text = message
        label?.textColor = isAvailable ? .brandMain : .error
        textField?.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.error.cgColor
    }
    
    // MARK: - Selectors
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let userName = socialSignUpView.userNameTextField.text else { return }
        viewModel.checkUserNameValidation(userName: userName)
    }
    
    @objc private func signupButtonTapped() {
        viewModel.checkEmailAvailability(email: email)
    }
}
