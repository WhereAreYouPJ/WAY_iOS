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
        view.addSubview(searchIDView)
        searchIDView.frame = view.bounds
        configureNavigationBar(title: "아이디 찾기", backButtonAction: #selector(backButtonTapped))
        actionButton()
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func confirmButtonTapped() {
        let controller = CheckIDViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Helpers
    func actionButton() {
        searchIDView.bottomConfirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}
