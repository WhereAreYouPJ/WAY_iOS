//
//  SearchIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/6/2024.
//

import UIKit
import SnapKit

class AccountSearchViewController: UIViewController {
    // MARK: - Properties
    let accountSearchView = AccountSearchView()
    private var viewModel: AcoountSearchViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = accountSearchView
        configureNavigationBar(title: "아이디 찾기", backButtonAction: #selector(backButtonTapped))
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = AcoountSearchViewModel(
            emailSendUseCase: EmailSendUseCaseImpl(memberRepository: memberRepository),
            emailVerifyUseCase: EmailVerifyUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupBindings() {
        // 인증코드 요청 성공
        viewModel.onRequestCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.emailErrorLabel.text = message
                self?.accountSearchView.emailErrorLabel.textColor = .brandColor
                self?.accountSearchView.authStack.isHidden = false
                self?.accountSearchView.requestAuthButton.configuration?.attributedTitle = AttributedString("인증요청 완료")
            }
        }
        
        // 인증코드 요청 실패
        viewModel.onRequestCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.emailErrorLabel.text = message
                self?.accountSearchView.emailErrorLabel.textColor = .warningColor
            }
        }
        
        // 인증코드 확인 성공
        viewModel.onVerifyCodeSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.authNumberErrorLabel.text = message
                self?.accountSearchView.authNumberErrorLabel.textColor = .brandColor
            }
        }
        
        // 인증코드 확인 실패
        viewModel.onVerifyCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.accountSearchView.authNumberErrorLabel.text = message
                self?.accountSearchView.authNumberErrorLabel.textColor = .warningColor
            }
        }
        
        // TODO: 이메일 계정 검색하는 API물어본 뒤에 수정하기
        // 아이디 찾기 성공
        viewModel.onAccountSearchSuccess = { [weak self] in
            DispatchQueue.main.async {
//                let controller = CheckIDViewController(userId: userId)
//                let nav = UINavigationController(rootViewController: controller)
//                nav.modalPresentationStyle = .fullScreen
//                self?.present(nav, animated: true, completion: nil)
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
        viewModel.requestEmailCode(email: email)
    }
    
    @objc private func findUserId() {
        let code = accountSearchView.authNumberTextField.text ?? ""
        viewModel.verifyEmailCode(inputCode: code)
    }
    
    @objc func confirmButtonTapped() {
        viewModel.okayToMove()
    }
}
