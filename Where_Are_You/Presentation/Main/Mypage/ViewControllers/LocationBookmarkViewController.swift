//
//  LocationBookmarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import UIKit

class LocationBookmarkViewController: UIViewController {
    
    private let locationBookmarkView = LocationBookmarkView()
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.descriptionLabel.text = "아직은 즐겨찾기한 위치가 없어요. \n목록을 생성하여 좀 더 편리하게 \n일정 추가 시 위치를 선택할 수 있어요."
        //        view.borderView.snp.makeConstraints { make in
        //            make.height.equalTo(LayoutAdapter.shared.scale(value: 150))
        //        }
        return view
    }()
    
    var viewModel: LocationBookmarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(locationBookmarkView)
        view.addSubview(noDataView)
        
        setupTableView()
        setupViewModel()
        setupBindings()
        setupNavigationBar()
        
        locationBookmarkView.isHidden = true
        noDataView.isHidden = true
        
        viewModel.getLocationBookMark()
    }
    
    // MARK: - Helpers
    
    private func setupTableView() {
        locationBookmarkView.bookMarkTableView.delegate = self
        locationBookmarkView.bookMarkTableView.dataSource = self
        locationBookmarkView.bookMarkTableView.register(LocationBookMarkCell.self, forCellReuseIdentifier: LocationBookMarkCell.identifier)
        locationBookmarkView.bookMarkTableView.isEditing = false // 기본 편집 모드 꺼짐
    }
    
    private func setupViewModel() {
        let locationService = LocationService()
        let locationRepository = LocationRepository(locationService: locationService)
        viewModel = LocationBookmarkViewModel(getLocationUseCase: GetLocationUseCaseImpl(locationRepository: locationRepository))
    }
    
    private func setupNavigationBar() {
        let rightButton =  UIBarButtonItem(image: UIImage(systemName: "icon-plus"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(plusButtonTapped))
        Utilities.createNavigationBar(for: self, title: "위치 즐겨찾기", backButtonAction: #selector(backButtonTapped), rightButton: rightButton)
    }
    
    private func setupBindings() {
        viewModel.onGetLocationBookMark = { [weak self] in
            DispatchQueue.main.async {
                self?.showBookmarkView()
            }
        }
        
        viewModel.onEmptyLocation = { [weak self] in
            DispatchQueue.main.async {
                self?.showNoDataView()
            }
        }
    }
    
    private func showBookmarkView() {
        noDataView.isHidden = true
        locationBookmarkView.isHidden = false
        locationBookmarkView.bookMarkTableView.reloadData()
        locationBookmarkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showNoDataView() {
        noDataView.isHidden = false
        locationBookmarkView.isHidden = true
        noDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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

extension LocationBookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationBookMarkCell.identifier, for: indexPath) as? LocationBookMarkCell else { return UITableViewCell() }
        let location = viewModel.locations[indexPath.row]
        cell.configure(with: location)
        return cell
    }
}
