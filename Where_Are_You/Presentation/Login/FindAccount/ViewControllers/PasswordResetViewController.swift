//
//  ResetPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit

class PasswordResetViewController: UIViewController {
    // MARK: - Properties
    
    private let passwordResetView = PasswordResetView()
    private var viewModel: ResetPasswordViewModel!
    
    private var isPasswordValidate: Bool = false
    private var isPasswordCheck: Bool = false
    
    private var email: String = ""
    
    // MARK: - Lifecycle
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupViewmodel()
        setupBindings()
    }
    
    // MARK: - Helpers

    private func setupUI() {
        view = passwordResetView
        configureNavigationBar(title: "비밀번호 재설정", backButtonAction: #selector(backButtonTapped))
        passwordResetView.bottomButtonView.button.isEnabled = false
        passwordResetView.bottomButtonView.button.backgroundColor = .color171
    }
    
    private func setupViewmodel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = ResetPasswordViewModel(
            resetPasswordUseCase: ResetPasswordUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupBindings() {
        viewModel.onPasswordValidation = { [weak self] result in
            DispatchQueue.main.async {
                self?.isPasswordValidate = result
                self?.passwordResetView.resetPasswordDescription.text = "영문 대문자, 소문자로 시작하는 6~20자의 영문 대문자, 소문자, 숫자를 포함해 입력해주세요."
                self?.updateResetButtonState()
            }
        }
        
        viewModel.onPasswordCheck = { [weak self] result in
            DispatchQueue.main.async {
                self?.isPasswordCheck = result
                self?.passwordResetView.checkPasswordDescription.text = "비밀번호가 일치하지 않습니다."
                self?.updateResetButtonState()
            }
        }
        
        viewModel.onResetPasswordSuccess = { [weak self] in
            let controller = PasswordFinishResetViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }

    private func setupActions() {
        passwordResetView.resetPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordResetView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordResetView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let pw = passwordResetView.resetPasswordTextField.text,
              let checkpw = passwordResetView.checkPasswordTextField.text else { return }
        
        switch textField {
        case passwordResetView.resetPasswordTextField:
            viewModel.checkPasswordForm(pw: pw)
        case passwordResetView.checkPasswordTextField:
            viewModel.checkSamePassword(pw: pw, checkpw: checkpw)
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        guard let pw = passwordResetView.resetPasswordTextField.text,
              let checkpw = passwordResetView.checkPasswordTextField.text else { return }
        viewModel.resetPassword(email: email, password: pw, checkPassword: checkpw)
    }
    
    private func updateResetButtonState() {
        if isPasswordValidate && isPasswordCheck {
            passwordResetView.bottomButtonView.button.backgroundColor = .brandColor
            passwordResetView.bottomButtonView.button.isEnabled = true
        } else {
            passwordResetView.bottomButtonView.button.backgroundColor = .color171
            passwordResetView.bottomButtonView.button.isEnabled = false
        }
    }
}
