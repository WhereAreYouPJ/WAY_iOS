//
//  CheckIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class CheckIDViewController: UIViewController {
    // MARK: - Propeties
    let accountCheckView = AccountCheckView()
    var email: String = ""
    
    // MARK: - Lifecycle
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = accountCheckView
        setupUI()
        buttonActions()
    }
    // MARK: - Helpers
    
    func setupUI() {
        configureNavigationBar(title: "계정 찾기", showBackButton: false)
        accountCheckView.emailDescriptionLabel.text = email
    }
    
    func buttonActions() {
        accountCheckView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        accountCheckView.searchPasswordButton.addTarget(self, action: #selector(searchPasswordButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func loginButtonTapped() {
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func searchPasswordButtonTapped() {
        print("비밀번호 재설정 버튼 눌림")
        let controller = PasswordResetViewController(email: email)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
