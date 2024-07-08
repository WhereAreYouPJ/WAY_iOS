//
//  ResetPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    // MARK: - Properties
    
    let resetPasswordView = ResetPasswordView()
    private var viewModel: ResetPasswordViewModel!
    
    var userId: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupViewmodel()
        setupBindings()
        
    }
    
    func setupUI() {
        view = resetPasswordView
        configureNavigationBar(title: "비밀번호 찾기", backButtonAction: #selector(backButtonTapped))
    }
    
    func setupViewmodel() {
        let authService = AuthService()
        let userRepository = UserRepository(authService: authService)
        viewModel = ResetPasswordViewModel(
            resetPasswordUseCase: ResetPasswordUseCaseImpl(userRepository: userRepository)
        )
    }
    
    func setupBindings() {
        
        viewModel.onCheckPasswordForm = { [weak self] message, isAvailable in
            self?.resetPasswordView.resetPasswordDescription.text = message
            self?.resetPasswordView.resetPasswordTextField.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
        }
        
        viewModel.onCheckSamePassword = { [weak self] message, isAvailable in
            self?.resetPasswordView.checkPasswordDescription.text = message
            self?.resetPasswordView.checkPasswordTextField.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
        }
        
        viewModel.onResetPasswordSuccess = { [weak self] in
            let controller = FinishResetPasswordViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
        
        viewModel.onResetPasswordFailure = { [weak self] message in
            self?.showAlert(title: "비밀번호 재설정 실패", message: message)
        }
    }
    // MARK: - Helpers

    func setupActions() {
        resetPasswordView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        resetPasswordView.resetPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        resetPasswordView.checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let pw = resetPasswordView.resetPasswordTextField.text,
              let checkpw = resetPasswordView.checkPasswordTextField.text else { return }
        
        switch textField {
        case resetPasswordView.resetPasswordTextField:
            viewModel.password = pw
            viewModel.checkPasswordForm(pw: pw)
        case resetPasswordView.checkPasswordTextField:
            viewModel.checkSamePassword(pw: pw, checkpw: checkpw)
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        guard let pw = resetPasswordView.resetPasswordTextField.text,
              let checkpw = resetPasswordView.checkPasswordTextField.text else { return }
        viewModel.resetPassword(userId: userId, password: pw, checkPassword: checkpw)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
