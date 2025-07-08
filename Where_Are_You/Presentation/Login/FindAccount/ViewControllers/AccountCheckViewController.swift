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
    var emailType: [String] = []
    
    // MARK: - Lifecycle
    init(email: String, emailType: [String]) {
        self.email = email
        self.emailType = emailType
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
        accountCheckView.setupLogoImage(email: email, emailType: emailType)
    }
    
    func buttonActions() {
        accountCheckView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        accountCheckView.searchPasswordButton.addTarget(self, action: #selector(searchPasswordButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func loginButtonTapped() {
        let controller = LoginViewController()
        rootToViewcontroller(controller)
    }
    
    @objc func searchPasswordButtonTapped() {
        let controller = PasswordResetViewController(email: email)
        pushToViewController(controller)
    }
}
