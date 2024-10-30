//
//  LocationBookmarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import UIKit

class LocationBookmarkViewController: UIViewController {
    
    private let locationBookmarkView = LocationBookmarkView()
    private var isEditingMode = false // 삭제 모드인지 조건
    
    private var selectedLocations: Set<Int> = [] // 선택된 위치들 저장할 set
    
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.descriptionLabel.text = "아직은 즐겨찾기한 위치가 없어요. \n목록을 생성하여 좀 더 편리하게 \n일정 추가 시 위치를 선택할 수 있어요."
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-plus"), for: .normal)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        button.tintColor = .brandColor
        return button
    }()
    
    var viewModel: LocationBookmarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupActions()
        setupTableView()
        setupBindings()
        setupNavigationBar()
        setupOutsideTap()
        
        locationBookmarkView.translatesAutoresizingMaskIntoConstraints = false
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.getLocationBookMark()
        locationBookmarkView.bookMarkTableView.reloadData()
        
        locationBookmarkView.updateDeleteButtonState(isEnabled: false)
    }
    
    // MARK: - Helpers
    
    private func setupTableView() {
        locationBookmarkView.bookMarkTableView.delegate = self
        locationBookmarkView.bookMarkTableView.dataSource = self
        locationBookmarkView.bookMarkTableView.register(LocationBookMarkCell.self, forCellReuseIdentifier: LocationBookMarkCell.identifier)
        locationBookmarkView.bookMarkTableView.allowsMultipleSelection = true
        locationBookmarkView.bookMarkTableView.setEditing(true, animated: false)
    }
    
    private func setupViewModel() {
        let locationService = LocationService()
        let locationRepository = LocationRepository(locationService: locationService)
        viewModel = LocationBookmarkViewModel(getLocationUseCase: GetLocationUseCaseImpl(locationRepository: locationRepository), deleteLocationUseCase: DeleteLocationUseCaseImpl(locationRepository: locationRepository))
    }
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "위치 즐겨찾기", backButtonAction: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
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
        
        viewModel.onDeleteLocationSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.locationBookmarkView.bookMarkTableView.reloadData()
                self?.editingButtonTapped() // 삭제 후 편집 모드 종료
            }
        }
        
        viewModel.onDeleteLocationFailure = { error in
            print("Delete failed with error: \(error.localizedDescription)")
        }
        
        viewModel.onSelectionChanged = { [weak self] hasSelectedLocations in
            DispatchQueue.main.async {
                self?.locationBookmarkView.updateDeleteButtonState(isEnabled: hasSelectedLocations)
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
        locationBookmarkView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func setupOutsideTap() {
        view.hideWhenTappedOutside(ignoreViews: [locationBookmarkView.editingButton]) {
            self.locationBookmarkView.editingButton.isHidden = true
        }
    }
    
    // MARK: - Selectors
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func plusButtonTapped() {
        locationBookmarkView.editingButton.isHidden = false
    }
    
    @objc private func editingButtonTapped() {
        // 위치 삭제 모드로 전환
        isEditingMode.toggle()
        
        if isEditingMode {
            viewModel.checkedLocations.removeAll()
        }
        
        locationBookmarkView.editingButton.isHidden = isEditingMode
        addButton.isHidden = isEditingMode
        locationBookmarkView.deleteButton.isHidden = !isEditingMode
        locationBookmarkView.bookMarkTableView.reloadData()
    }
    
    @objc private func deleteButtonTapped() {
        print("deleteButtonTapped")
        viewModel.deleteSelectedLocations()
    }
}

extension LocationBookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutAdapter.shared.scale(value: 46)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationBookMarkCell.identifier, for: indexPath) as? LocationBookMarkCell else { return UITableViewCell() }
        let location = viewModel.locations[indexPath.row]
        
        // 셀에 현재 선택 상태 전달
        cell.configure(with: location, isSelected: viewModel.isLocationChecked(at: indexPath.row), isEditingMode: isEditingMode)
        
        // 선택 액션 설정
        cell.selectionAction = { [weak self] in
            self?.viewModel.toggleLocationCheck(at: indexPath.row) // 선택 상태 변경
            tableView.reloadRows(at: [indexPath], with: .none) // 선택된 셀만 새로고침
        }
        
        return cell
    }
    
    // MARK: - MoveRow

    // 특정 행을 드래그해서 이동할 수 있게 허용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !isEditingMode
    }
    
    // 순서를 변경할 수 있는 메서드 추가
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveLocation(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // MARK: - EditRow
    
    // 편집 모드에서 삭제 가능 여부 설정 (순서 변경만 허용할 때는 false로 설정)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
