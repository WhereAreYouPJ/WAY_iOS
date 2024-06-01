//
//  AccountLoginController.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class AccountLoginController: UIViewController {
    // MARK: - Properties
    private let accountLoginView = AccountLoginView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountLoginView)
        accountLoginView.frame = view.bounds
    
        configureNavigationBar()
    
        accountLoginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        accountLoginView.findAccountButton.button.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        accountLoginView.signupButton.addTarget(self, action: #selector(registerAccountButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func loginButtonTapped() {
        // 아이디, 비번 확인하고 로그인 체크
        print("login button tapped")
    }
    
    @objc func findAccountButtonTapped() {
        let controller = FindAccountController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func registerAccountButtonTapped() {
        // 회원가입 이동하기
        print("registerAccountTapped")
    }
    
    // MARK: - Helpers
    
    func configureNavigationBar() {
        
        let image = UIImage(systemName: "arrow.backward")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .color172
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "로그인"
    }
}
