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
    var userId = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = checkIDView
        
        buttonActions()
        configureNavigationBar(title: "아이디 찾기", showBackButton: false)
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
    
    // MARK: - Helpers
    func buttonActions() {
        checkIDView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        checkIDView.searchPasswordButton.addTarget(self, action: #selector(searchPasswordButtonTapped), for: .touchUpInside)
    }
}
