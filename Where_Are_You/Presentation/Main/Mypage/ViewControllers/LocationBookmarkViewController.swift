//
//  LocationBookmarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import UIKit

class LocationBookmarkViewController: UIViewController {
    
    private let locationBookmarkView = LocationBookmarkView()
    private let noDataView = NoDataView()
    
    var viewModel: LocationBookmarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewVisibility()
        viewModel = LocationBookmarkViewModel()
        setupBindings()
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    private func updateViewVisibility() {
        // FeedsViewController보고 참고하기
        // 위치 즐겨찾기가 없는경우 noDataView가 뜨게 하고
        // 정보가 있는경우 bookMark가 뜨게 하면됨.
        view = noDataView
    }
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "위치 즐겨찾기", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupBindings() {
        
    }
    
    // MARK: - Selectors

    @objc private func backButtonTapped() {
        // 뒤로가기 버튼 눌림
    }
}
