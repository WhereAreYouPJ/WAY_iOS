//
//  CheckPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class CheckPasswordViewController: UIViewController {
    // MARK: - Properties
    let checkPasswordView = CheckPasswordView()
    private var viewModel: DeleteMemberViewModel!
    
    var comment: String = ""
    private var passwordEnter: Bool = false
    
    // MARK: - Lifecycle
    init(comment: String) {
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupViewModel()
        setupBindings()
    }
    
    // MARK: - Helpers
   private func setupUI() {
       self.view = checkPasswordView
       configureNavigationBar(title: "회원 탈퇴", backButtonAction: #selector(backButtonTapped))
       checkPasswordView.passwordTextField.isSecureTextEntry = true
   }
    
    private func setupActions() {
        checkPasswordView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        checkPasswordView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = DeleteMemberViewModel(deleteAccountUseCase: DeleteMemberUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onDeleteAccount = { [weak self] deleteSucceed in
            if deleteSucceed {
                let controller = CompleteDeleteViewController()
                self?.navigationController?.pushViewController(controller, animated: true)
            } else {
                self?.updateStatus(label: self?.checkPasswordView.passwordErrorLabel,
                                   message: "비밀번호가 맞지 않습니다.",
                                   textField: self?.checkPasswordView.passwordTextField)
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // viewmodel에 로그인하기 버튼 활성화 비활성화 로직 추가하기
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkPasswordView.updateLoginButtonState()
    }
    
    @objc private func deleteButtonTapped() {
        guard let password = checkPasswordView.passwordTextField.text else {
            print("password가 nil 값입니다.")
            return
        }
        
        viewModel.deleteAccount(password: password, comment: comment, loginType: "normal")
    }
   
    private func updateStatus(label: UILabel?, message: String, textField: UITextField?) {
        label?.text = message
        label?.textColor = .error
        textField?.layer.borderColor = UIColor.error.cgColor
    }
}
