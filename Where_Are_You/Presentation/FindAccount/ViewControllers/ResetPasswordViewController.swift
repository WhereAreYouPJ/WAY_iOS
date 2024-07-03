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
    var userId: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = resetPasswordView
        
        configureNavigationBar(title: "비밀번호 찾기", backButtonAction: #selector(backButtonTapped))
        buttonActions()
    }

    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        let controller = FinishResetPasswordViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    func buttonActions() {
        resetPasswordView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

}
