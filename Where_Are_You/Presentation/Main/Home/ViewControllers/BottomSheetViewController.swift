//
//  DailyScheduleViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/1/2025.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private var isExpanded = false
    
    let bottomSheetView = BottomSheetView()

    let viewModel: BottomSheetViewModel
    
    var schedules: [Schedule] = [] {
        didSet {
            bottomSheetView.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    init(viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = bottomSheetView
        setupBindings()
        setupTableView()
        viewModel.fetchDailySchedule()
        
        setupGesture()
    }
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onDailyScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.schedules = self?.viewModel.getSchedules() ?? []
                self?.bottomSheetView.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        bottomSheetView.tableView.register(DailyScheduleTableViewCell.self, forCellReuseIdentifier: DailyScheduleTableViewCell.identifier)
        bottomSheetView.tableView.dataSource = self
        bottomSheetView.tableView.delegate = self
        bottomSheetView.tableView.rowHeight = UITableView.automaticDimension
        bottomSheetView.tableView.allowsSelection = false
        bottomSheetView.tableView.separatorStyle = .none
    }
    
    private func setupGesture() {
        bottomSheetView.sheetHeaderButton.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
    }
    
    @objc func headerButtonTapped() {
        bottomSheetView.contentStackView.isHidden = false

        bottomSheetView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 420))
        }
    }
}

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSchedules().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyScheduleTableViewCell.identifier, for: indexPath) as? DailyScheduleTableViewCell else {
            return UITableViewCell()
        }
        let schedule = viewModel.getSchedules()[indexPath.item]
        cell.configure(with: schedule)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutAdapter.shared.scale(value: 73)
    }
}

extension BottomSheetViewController: DailyScheduleTableViewCellDelegate {
    func didTapCheckLocationButton(schedule: Schedule) {
        
    }
}
