//
//  AccountLoginController.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class AccountLoginController: UIViewController {
    // MARK: - Properties
    
    private let accountView = AccountLogin()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountView)
        accountView.frame = view.bounds
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        accountView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        accountView.findAccountButton.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        
    }
    
    @objc func loginButtonTapped() {
        print("login button tapped")
    }
    
    @objc func findAccountButtonTapped() {
        print("findAccountbutton Tapped")
    }
    
    // MARK: - Helpers

    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "로그인"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: "arrow.backward", target: self, action: #selector(backButtonTapped))
    }
}
