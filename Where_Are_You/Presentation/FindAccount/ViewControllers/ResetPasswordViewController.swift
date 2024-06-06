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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resetPasswordView)
        resetPasswordView.frame = view.bounds
        
        configureNavigationBar(title: "비밀번호 찾기", backButtonAction: #selector(backButtonTapped))
        buttonActions()
    }

    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        print("비밀번호 페이지")
    }

    func buttonActions() {
        resetPasswordView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

}
