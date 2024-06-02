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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(checkIDView)
        checkIDView.frame = view.bounds
        
        buttonAction()
        configureNavigationBar()
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
    func buttonAction() {
        checkIDView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        checkIDView.searchPasswordButton.addTarget(self, action: #selector(searchPasswordButtonTapped), for: .touchUpInside)
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "아이디 찾기"
    }
}
