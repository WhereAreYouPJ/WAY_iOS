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
        setupViewModel()
        updateViewVisibility()
        setupBindings()
        setupNavigationBar()
        
        viewModel.getLocationBookMark()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let locationService = LocationService()
        let locationRepository = LocationRepository(locationService: locationService)
        viewModel = LocationBookmarkViewModel(getLocationUseCase: GetLocationUseCaseImpl(locationRepository: locationRepository))
    }
    
    private func updateViewVisibility() {
        // FeedsViewController보고 참고하기
        // 위치 즐겨찾기가 없는경우 noDataView가 뜨게 하고
        // 정보가 있는경우 bookMark가 뜨게 하면됨.
        noDataView.descriptionLabel.text = "아직은 즐겨찾기한 위치가 없어요. \n목록을 생성하여 좀 더 편리하게 \n일정 추가 시 위치를 선택할 수 있어요."
        noDataView.borderView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 150))
        }
        view = noDataView
    }
    
    private func setupNavigationBar() {
        let rightButton =  UIBarButtonItem(image: UIImage(systemName: "icon-plus"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(plusButtonTapped))
        Utilities.createNavigationBar(for: self, title: "위치 즐겨찾기", backButtonAction: #selector(backButtonTapped), rightButton: rightButton)
    }
    
    private func setupBindings() {
        viewModel.onGetLocationBookMarkSuccess = { [weak self] data in
            DispatchQueue.main.async {
                // 데이터 있을때 불러오는거
            }
        }
        
        viewModel.onGetLocationBookMarkFailure = { [weak self]  in
            DispatchQueue.main.async {
                // 데이터 없는 상태
            }
        }
    }
    
    // MARK: - Selectors

    @objc private func backButtonTapped() {
        // 뒤로가기 버튼 눌림
    }
    
    @objc private func plusButtonTapped() {
        // 위치 삭제 버튼 나타남(custom option button 사용)
        locationBookmarkView.editingButton.isHidden = false
    }
    
    @objc private func editingButtonTapped() {
        // 위치 삭제하기로 뷰 변경
        locationBookmarkView.editingButton.isHidden = true
        locationBookmarkView.deleteButton.isHidden = false
        
    }
}
