//
//  MyDetailManageViewcontroller.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/8/2024.
//

import UIKit

class MyDetailManageViewcontroller: UIViewController {
    private let mydetailManageView = MyDetailManageView()
    
    var viewModel: MyDetailManageViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mydetailManageView
        viewModel = MyDetailManageViewModel()
        setupBindings()
        setupNavigationBar()
    }
    
    // MARK: - Helpers

    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "내 정보 관리", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupBindings() {
        
    }
    
    // MARK: - Selectors

    @objc private func backButtonTapped() {
        // 네비게이션 바 뒤로가기 버튼
    }
}
