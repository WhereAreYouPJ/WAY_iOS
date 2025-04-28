//
//  BottomSheetViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/1/2025.
//

import UIKit
import SwiftUI
import FloatingPanel

class BottomSheetViewController: UIViewController {
        
    let tableView = UITableView()
    
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
        
        setupBindings()
        setupTableView()
        viewModel.fetchDailySchedule { [weak self] hasSchedule in
            if hasSchedule {
                self?.schedules = self?.viewModel.getSchedules() ?? []
            } else {
                print("nodata")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchDailySchedule { [weak self] hasSchedule in
            if hasSchedule {
                self?.schedules = self?.viewModel.getSchedules() ?? []
            } else {
                print("nodata")
            }
        }
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.register(DailyScheduleTableViewCell.self, forCellReuseIdentifier: DailyScheduleTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 포맷
        formatter.dateFormat = "M월 d일" // 원하는 날짜 형식
        return formatter.string(from: Date())
    }
}

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    // Sticky Header 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .brandHighLight1
        
        let label = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: formattedDate(), textColor: .brandDark))
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
            make.top.equalToSuperview().inset(4)
        }
        
        return headerView
    }
}

//extension BottomSheetViewController: DailyScheduleTableViewCellDelegate {
//    func didTapCheckLocationButton(schedule: Schedule) {
//        let notificationView = NotificationView()
//        let hostingController = UIHostingController(rootView: notificationView)
//        hostingController.modalPresentationStyle = .fullScreen
//        present(hostingController, animated: true)
//    }
//}

extension BottomSheetViewController: DailyScheduleTableViewCellDelegate {
    func didTapCheckLocationButton(schedule: Schedule) {
        class FriendsLocationViewDismissHandler { // SwiftUI 뷰와 UIKit의 통신을 위한 클래스
            var dismissAction: (() -> Void)?
        }
        
        let dismissHandler = FriendsLocationViewDismissHandler() // 핸들러 인스턴스 생성
        dismissHandler.dismissAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let isShownBinding = Binding<Bool>( // isShownView 바인딩 생성
            get: { true },
            set: { newValue in
                if !newValue {
                    dismissHandler.dismissAction?() // isShownView가 false로 설정되면 뷰 컨트롤러 dismiss
                }
            }
        )
        
        let friendsLocationView = FriendsLocationView( // FriendsLocationView 생성
            isShownView: isShownBinding,
            schedule: .constant(schedule)
        )
        
        let hostingController = UIHostingController(rootView: friendsLocationView) // SwiftUI 뷰를 UIKit 컨트롤러에 래핑
        
        hostingController.modalPresentationStyle = .fullScreen // 전체 화면으로 표시
        hostingController.view.backgroundColor = .clear
        
        present(hostingController, animated: true) // 뷰를 표시
    }
}
