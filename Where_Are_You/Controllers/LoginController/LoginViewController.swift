//
//  ViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        serviceButtonAction()
    }
    
    // MARK: - Helpers
    func setupView() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
        loginView.delegate = self
    }
    
    func serviceButtonAction() {
        loginView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        loginView.findAccountButton.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        
        loginView.inquiryButton.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func signupButtonTapped() {
        
    }
    
    @objc func findAccountButtonTapped() {
        
    }
    
    @objc func inquiryButtonTapped() {
        
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func accountLoginTapped() {
        let controller = AccountLoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        return
    }
    
}
