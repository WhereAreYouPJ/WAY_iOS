//
//  SearchIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/6/2024.
//

import UIKit
import SnapKit

class SearchIDViewController: UIViewController {
    // MARK: - Properties
    let searchIDView = SearchAuthView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchIDView
        configureNavigationBar(title: "아이디 찾기", backButtonAction: #selector(backButtonTapped))
        actionButton()
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc func confirmButtonTapped() {
        let controller = CheckIDViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Helpers
    func actionButton() {
        searchIDView.bottomButtonView.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}
