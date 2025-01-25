//
//  SearchIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/6/2024.
//

import UIKit

class AccountSearchViewController: UIViewController {
    // MARK: - Properties
    let accountSearchView = AccountSearchView()
    private var viewModel: AcoountSearchViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view = accountSearchView
        configureNavigationBar(title: "계정 찾기", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = AcoountSearchViewModel(
            emailSendUseCase: EmailSendUseCaseImpl(memberRepository: memberRepository),
            emailVerifyUseCase: EmailVerifyUseCaseImpl(memberRepository: memberRepository),
            checkEmailUseCase: CheckEmailUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupBindings() {
        // 인증코드 요청 성공
        viewModel.onRequestCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.emailErrorLabel.text = message
                self?.accountSearchView.emailErrorLabel.textColor = .brandColor
                self?.accountSearchView.authStack.isHidden = false
                self?.accountSearchView.requestAuthButton.updateTitle("인증요청 완료")
                self?.accountSearchView.requestAuthButton.updateBackgroundColor(.color171)
                self?.accountSearchView.requestAuthButton.isEnabled = false
            }
        }
        
        // 인증코드 요청 실패
        viewModel.onRequestCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.emailErrorLabel.text = message
                self?.accountSearchView.emailErrorLabel.textColor = .error
            }
        }
        
        // 인증코드 확인 성공
        viewModel.onVerifyCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.authNumberErrorLabel.text = message
                self?.accountSearchView.authNumberErrorLabel.textColor = .brandColor
                self?.accountSearchView.authNumberCheckButton.updateTitle("인증 완료")
                self?.accountSearchView.authNumberCheckButton.updateBackgroundColor(.color171)
                self?.accountSearchView.authNumberCheckButton.isEnabled = false
                self?.accountSearchView.bottomButtonView.button.isEnabled = true
                self?.accountSearchView.bottomButtonView.button.updateBackgroundColor(.brandColor)
            }
        }
        
        // 인증코드 확인 실패
        viewModel.onVerifyCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.authNumberErrorLabel.text = message
                self?.accountSearchView.authNumberErrorLabel.textColor = .error
            }
        }
        
        // 아이디 찾기 성공
        viewModel.onAccountSearchSuccess = { [weak self] email in
            DispatchQueue.main.async {
                let controller = CheckIDViewController(email: email)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
            }
        }
        
        // 타이머 업데이트
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.accountSearchView.timer.text = timeString
            }
        }
    }
    
    private func setupActions() {
        accountSearchView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        accountSearchView.requestAuthButton.addTarget(self, action: #selector(requestAuthCodeTapped), for: .touchUpInside)
        accountSearchView.authNumberCheckButton.addTarget(self, action: #selector(findUserId), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func requestAuthCodeTapped() {
        let email = accountSearchView.emailTextField.text ?? ""
        viewModel.checkEmailAvailability(email: email)
    }
    
    @objc private func findUserId() {
        let code = accountSearchView.authNumberTextField.text ?? ""
        viewModel.verifyEmailCode(code: code)
    }
    
    @objc func confirmButtonTapped() {
        viewModel.okayToMove()
    }
}
