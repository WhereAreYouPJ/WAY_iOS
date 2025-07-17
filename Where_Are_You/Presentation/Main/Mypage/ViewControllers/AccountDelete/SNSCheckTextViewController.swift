//
//  SNSCheckTextViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/7/2025.
//

import UIKit

class SNSCheckTextViewController: UIViewController {
    // MARK: - Properties
    let snsCheckTextView = SNSCheckTextView()
    private var viewModel: DeleteMemberViewModel!
    
    var comment: String = ""
    
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
       self.view = snsCheckTextView
       configureNavigationBar(title: "회원 탈퇴", backButtonAction: #selector(backButtonTapped))
   }
    
    private func setupActions() {
        snsCheckTextView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        snsCheckTextView.checkTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = DeleteMemberViewModel(deleteAccountUseCase: DeleteMemberUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onSucceedDeleteAccount = { [weak self] in
            DispatchQueue.main.async {
                    self?.succeedDelete()
            }
        }
        
        viewModel.onFailureDeleteAccount = { [weak self] in
            DispatchQueue.main.async {
                self?.snsCheckTextView.checkErrorLabel.text = "서버오류"
            }
        }
    }
    
    private func succeedDelete() {
        UserDefaultsManager.shared.clearData()
        let controller = CompleteDeleteViewController()
        pushToViewController(controller)
    }
    
    // MARK: - Selectors
    @objc private func backButtonTapped() {
        popViewController()
    }
    
    // viewmodel에 로그인하기 버튼 활성화 비활성화 로직 추가하기
    @objc private func textFieldDidChange(_ textField: UITextField) {
        snsCheckTextView.updateLoginButtonState()
    }
    
    @objc private func deleteButtonTapped() {
        let loginType = UserDefaultsManager.shared.getLoginType()
        viewModel.deleteAccount(password: "", comment: comment, loginType: loginType)
    }
}
