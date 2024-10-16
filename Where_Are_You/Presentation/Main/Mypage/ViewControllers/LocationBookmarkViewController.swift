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
        return view
    }()
    
    var viewModel: LocationBookmarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        setupTableView()
        setupViewModel()
        setupBindings()
        setupNavigationBar()
        
        locationBookmarkView.translatesAutoresizingMaskIntoConstraints = false
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        
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
        let rightButton =  UIBarButtonItem(image: UIImage(named: "icon-plus"),
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
        noDataView.removeFromSuperview()
        view.addSubview(locationBookmarkView)
        locationBookmarkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        locationBookmarkView.bookMarkTableView.reloadData()
    }
    
    private func showNoDataView() {
        locationBookmarkView.removeFromSuperview()
        view.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        locationBookmarkView.editingButton.button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        locationBookmarkView.deleteButton.button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
    
    @objc private func deleteButtonTapped() {
        // 삭제하기 버튼 눌림
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
    
    // 순서를 변경할 수 있는 메서드 추가
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveLocation(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // 편집 모드에서 삭제 가능 여부 설정 (순서 변경만 허용할 때는 false로 설정)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 특정 행을 드래그해서 이동할 수 있게 허용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
