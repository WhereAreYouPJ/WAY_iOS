//
//  SignUpFormViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit

class SignUpFormViewController: UIViewController {
    // MARK: - Properties
    
    let signUpView = SignUpFormView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUpView)
        signUpView.frame = view.bounds
        
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
    }
    
    // MARK: - Helpers
    
    func buttonActions() {
        signUpView.bottomConfirmButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func startButtonTapped() {
        
    }
}
