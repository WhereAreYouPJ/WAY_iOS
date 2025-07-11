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
    
    private var code: String = ""
    private var userName: String = ""
    private var snsType: SnsType
    
    // MARK: - Lifecycle
    init(code: String, userName: String, snsType: SnsType) {
        self.code = code
        self.userName = userName
        self.snsType = snsType
        super.init(nibName: nil, bundle: nil)
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
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = SocialSignUpViewModel(
            appleJoinUseCae: AppleJoinUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.moveToSignUpSuccess()
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
        if snsType == .apple {
            viewModel.appleJoin(userName: userName, code: code)
        } else {
            // 카카오 회원가입 - 주희님
        }
    }
    
    @objc private func backButtonTapped() {
        let controller = LoginViewController()
        rootToViewcontroller(controller)
    }
}
