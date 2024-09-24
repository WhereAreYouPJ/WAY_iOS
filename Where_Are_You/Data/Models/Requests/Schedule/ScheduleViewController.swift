//import UIKit
//import SwiftUI
//
//class ScheduleViewController: UIViewController {
//    // MARK: - Properties
//    private var scheduleHostingController: UIHostingController<ScheduleView>?
//    private var viewModel = ScheduleViewModel()
//    
//    let notificationButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-notification"), for: .normal)
//        button.tintColor = .brandColor
//        return button
//    }()
//    
//    lazy var addButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-plus"), for: .normal)
//        button.tintColor = .brandColor
//        button.showsMenuAsPrimaryAction = true
//        button.menu = createMenu()
//        return button
//    }()
//    
//    private lazy var barButtonStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [notificationButton, addButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigationBar()
//        setupUI()
//        setupConstraints()
//        setupActions()
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        // Setup ScheduleView
//        let scheduleView = ScheduleView()
//        scheduleHostingController = UIHostingController(rootView: scheduleView)
//        if let scheduleHostingController = scheduleHostingController {
//            addChild(scheduleHostingController)
//            view.addSubview(scheduleHostingController.view)
//            scheduleHostingController.didMove(toParent: self)
//        }
//        
//        // Setup navigation items
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
//    }
//    
//    private func setupConstraints() {
//        scheduleHostingController?.view.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        addButton.snp.makeConstraints { make in
//            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 34))
//        }
//    }
//    
//    private func setupActions() {
//        notificationButton.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
//    }
//    
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
//    }
//    
//    // MARK: - Menu Creation
//    private func createMenu() -> UIMenu {
//        let createScheduleAction = UIAction(title: "일정 추가") { [weak self] _ in
//            self?.handleCreateSchedule()
//        }
//
//        return UIMenu(title: "", children: [createScheduleAction])
//    }
//    
//    // MARK: - Actions
//    @objc private func handleNotification() {
//        print("알림 페이지로 이동")
//    }
//    
//    private func handleCreateSchedule() {
//        print("일정 추가")
//        let createScheduleView = CreateScheduleView()
//        let hostingController = UIHostingController(rootView: createScheduleView)
//        hostingController.modalPresentationStyle = .formSheet
//        present(hostingController, animated: true, completion: nil)
//    }
//}
//
//// SwiftUI Preview
//struct ScheduleViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ScheduleViewController {
//        return ScheduleViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: ScheduleViewController, context: Context) {}
//}
//
//#Preview {
//    ScheduleViewControllerRepresentable()
//}
