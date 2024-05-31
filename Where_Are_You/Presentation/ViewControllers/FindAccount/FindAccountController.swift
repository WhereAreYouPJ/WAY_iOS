//
//  FindAccountController.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit

class FindAccountController: UIViewController {
    // MARK: - Properties
    private let findAccountView = FindAccount()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        buttonAction()
        configureNavigationBar()
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func searchID() {
        print("saerchID")
    }
    
    @objc func resetPassword() {
        print("resetPassword")
    }

    // MARK: - Helpers
    func setupView() {
        view.addSubview(findAccountView)
        findAccountView.frame = view.bounds
    }
    
    func buttonAction() {
        findAccountView.findID.addTarget(self, action: #selector(searchID), for: .touchUpInside)
        findAccountView.resetPassword.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }
    
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
        
        navigationItem.title = "계정찾기"
    }
}
