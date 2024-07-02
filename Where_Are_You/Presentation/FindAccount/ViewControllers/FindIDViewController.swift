//
//  SearchIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/6/2024.
//

import UIKit
import SnapKit

class FindIDViewController: UIViewController {
    // MARK: - Properties
    let searchIDView = SearchAuthView()
    private var viewModel: FindIDViewModel!
    var userId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchIDView
        configureNavigationBar(title: "아이디 찾기", backButtonAction: #selector(backButtonTapped))
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let apiService = APIService()
        let userRepository = UserRepository(apiService: apiService)
        let sendEmailVerificationCodeUseCase = SendEmailVerificationCodeUseCaseImpl(userRepository: userRepository)
        let findUserIDUseCase = FindUserIDUseCaseImpl(userRepository: userRepository)
        
        viewModel = FindIDViewModel(
            sendEmailVerificationCodeUseCase: sendEmailVerificationCodeUseCase,
            findUserIDUseCase: findUserIDUseCase
        )
    }
    
    private func setupBindings() {
        // 인증코드 요청 성공
        viewModel.onRequestCodeSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.email = self?.searchIDView.emailTextField.text ?? ""
                self?.searchIDView.emailErrorLabel.text = "인증코드가 전송되었습니다."
                self?.searchIDView.emailErrorLabel.textColor = .brandColor
            }
        }
        
        // 인증코드 요청 실패
        viewModel.onRequestCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchIDView.emailErrorLabel.text = message
                self?.searchIDView.emailErrorLabel.textColor = .warningColor
            }
        }
        
        // 인증코드 확인 성공
        viewModel.onVerifyCodeSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.searchIDView.authNumberErrorLabel.text = "인증코드가 확인되었습니다."
                self?.searchIDView.authNumberErrorLabel.textColor = .brandColor
            }
        }
        
        // 인증코드 확인 실패
        viewModel.onVerifyCodeFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.searchIDView.authNumberErrorLabel.text = message
                self?.searchIDView.authNumberErrorLabel.textColor = .warningColor
            }
        }
        
        // 아이디 찾기 성공
        viewModel.onFindIDSuccess = { [weak self] userId in
            DispatchQueue.main.async {
                // 여기의 userid를 다음 화면에 넘기기
                self?.userId = userId
            }
        }
        
        // 아이디 찾기 실패
        viewModel.onFindIDFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "아이디 찾기 실패", message: message)
            }
        }
        
        // 타이머 업데이트
        viewModel.onUpdateTimer = { [weak self] timeString in
            DispatchQueue.main.async {
                self?.searchIDView.timer.text = timeString
            }
        }
    }
    
    private func setupActions() {
        searchIDView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        searchIDView.requestAuthButton.addTarget(self, action: #selector(requestAuthCodeTapped), for: .touchUpInside)
        searchIDView.authNumberCheckButton.addTarget(self, action: #selector(findUserId), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func requestAuthCodeTapped() {
        let email = searchIDView.emailTextField.text ?? ""
        viewModel.sendEmailVerificationCode(email: email)
    }
    
    @objc private func findUserId() {
        let code = searchIDView.authNumberTextField.text ?? ""
        viewModel.findUserID(code: code)
    }
    
    @objc func confirmButtonTapped() {
        if userId.isEmpty {
            showAlert(title: "아이디 찾기 실패", message: "아이디가 존재하지 않습니다.")
        } else {
            // 다음화면 userid 데이터를 가지고 넘어가야함
            let controller = CheckIDViewController()
            controller.userId = userId
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
