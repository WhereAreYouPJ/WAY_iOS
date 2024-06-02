//
//  SearchPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class SearchPasswordViewController: UIViewController {
    // MARK: - Properties
    
    let searchPasswordView = SearchIDView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchPasswordView)
        searchPasswordView.frame = view.bounds
        
        setupUI()
        configureNavigationBar()
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func setupUI() {
        searchPasswordView.emailLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "아이디", textColor: .color51, fontSize: 12)
    
        searchPasswordView.emailTextField.placeholder = "아이디"
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
        navigationItem.title = "비밀번호 찾기"
    }
}
