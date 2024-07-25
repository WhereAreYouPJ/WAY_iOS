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
    let checkIDView = CheckIDView()
    var userId: String = ""
    
    // MARK: - Lifecycle
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = checkIDView
        setupUI()
        buttonActions()
    }
    // MARK: - Helpers
    
    func setupUI() {
        configureNavigationBar(title: "아이디 찾기", showBackButton: false)
        checkIDView.idDescriptionLabel.text = userId
    }
    
    func buttonActions() {
        checkIDView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        checkIDView.searchPasswordButton.addTarget(self, action: #selector(searchPasswordButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func loginButtonTapped() {
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func searchPasswordButtonTapped() {
        let controller = SearchPasswordViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
}
