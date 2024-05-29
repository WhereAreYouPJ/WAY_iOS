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
        buttonAction()
    }
    
    // MARK: - Helpers
    func setupView() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
    }
    
    func buttonAction() {
        loginView.kakaoLogin.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        loginView.appleLogin.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        loginView.accountLogin.addTarget(self, action: #selector(accountLoginTapped), for: .touchUpInside)
        loginView.signupButton.button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
//        loginView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        loginView.findAccountButton.button.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        loginView.inquiryButton.button.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func kakaoLoginTapped() {
        
    }
    
    @objc func appleLoginTapped() {
        
    }
    
    @objc func accountLoginTapped() {
        let controller = AccountLoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func signupButtonTapped() {
        
    }
    
    @objc func findAccountButtonTapped() {
        
    }
    
    @objc func inquiryButtonTapped() {
        
    }
}
