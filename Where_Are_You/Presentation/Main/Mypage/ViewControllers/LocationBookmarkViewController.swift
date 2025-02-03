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
        view.configureUI(descriptionText: "아직은 즐겨찾기한 위치가 없어요. \n목록을 생성하여 좀 더 편리하게 \n일정 추가 시 위치를 선택할 수 있어요.")
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
//        setupOutsideTap()
        setupViews()
    }
    
    // MARK: - Helpers
    private func setupViews() {
        locationBookmarkView.translatesAutoresizingMaskIntoConstraints = false
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        
        // 테이블뷰 왼쪽 여백 지우는 코드
        locationBookmarkView.bookMarkTableView.separatorInset = .zero
        
        // tableHeaderView에 빈 뷰 추가하여 최상단 분리선 숨기기
        locationBookmarkView.bookMarkTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: locationBookmarkView.bookMarkTableView.bounds.width, height: 1))
        
        viewModel.getLocationBookMark()
        locationBookmarkView.bookMarkTableView.reloadData()
        
        locationBookmarkView.updateDeleteButtonState(isEnabled: false)
    }
    
    private func setupTableView() {
        locationBookmarkView.bookMarkTableView.delegate = self
        locationBookmarkView.bookMarkTableView.dataSource = self
        locationBookmarkView.bookMarkTableView.register(LocationBookMarkCell.self, forCellReuseIdentifier: LocationBookMarkCell.identifier)
        
        locationBookmarkView.bookMarkTableView.allowsSelectionDuringEditing = true
        locationBookmarkView.bookMarkTableView.allowsSelection = false
        locationBookmarkView.bookMarkTableView.setEditing(true, animated: false)
    }
    
    private func setupViewModel() {
        let locationService = LocationService()
        let locationRepository = LocationRepository(locationService: locationService)
        viewModel = LocationBookmarkViewModel(getLocationUseCase: GetLocationUseCaseImpl(locationRepository: locationRepository), putLocationUseCase: PutLocationUseCaseImpl(locationRepository: locationRepository), deleteLocationUseCase: DeleteLocationUseCaseImpl(locationRepository: locationRepository))
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(title: "위치 즐겨찾기", backButtonAction: #selector(backButtonTapped), rightButton: UIBarButtonItem(customView: addButton))
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
                self?.setupViewMode(editMode: false)
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
        
        viewModel.onUpdateLocationSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.locationBookmarkView.bookMarkTableView.reloadData()
            }
        }
        
        viewModel.onUpdateLocationFailure = { [weak self] error in
            print(error)
            self?.locationBookmarkView.bookMarkTableView.reloadData()
        }
    }
    
    private func showBookmarkView() {
        noDataView.removeFromSuperview()
        view.addSubview(locationBookmarkView)
        locationBookmarkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupViewMode(editMode: false)
        locationBookmarkView.bookMarkTableView.reloadData()
    }
    
    private func showNoDataView() {
        locationBookmarkView.removeFromSuperview()
        view.addSubview(noDataView)
        addButton.isHidden = true
        noDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupViewMode(editMode: Bool) {
        isEditingMode = editMode
        locationBookmarkView.editingButton.isHidden = !editMode
        locationBookmarkView.deleteButton.isHidden = !editMode
        addButton.isHidden = editMode
        locationBookmarkView.bookMarkTableView.setEditing(!editMode, animated: true)
        locationBookmarkView.bookMarkTableView.reloadData()
    }
    
    private func setupActions() {
        locationBookmarkView.editingButton.button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        locationBookmarkView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateServerOrder() {
        viewModel.putLocation()
    }
    
    // MARK: - Selectors
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !locationBookmarkView.editingButton.frame.contains(location) {
            locationBookmarkView.editingButton.removeFromSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
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
        locationBookmarkView.bookMarkTableView.setEditing(!isEditingMode, animated: true)
    }
    
    @objc private func deleteButtonTapped() {
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
        updateServerOrder()
    }
    
    // MARK: - EditRow
    
    // 셀의 편집 스타일을 설정하여 삭제 버튼을 숨김
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none // 삭제 버튼이 나타나지 않도록 설정
    }
    
    // reorder control만 표시되도록 설정
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 드래그 시 인덴트 적용되지 않게 설정
    }
}
