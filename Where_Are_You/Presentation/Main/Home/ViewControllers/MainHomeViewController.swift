//
//  MainHomeViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import UIKit
import SwiftUI
import FloatingPanel

class MainHomeViewController: UIViewController {
    // MARK: - Properties
    private var mainHomeView = MainHomeView()
    
    var fpc: FloatingPanelController!
    
    private let bottomSheetViewController: BottomSheetViewController
    private let bannerViewController: BannerViewController
    private let dDayViewController: DDayViewController
    private let homeFeedViewController: HomeFeedViewController
    
    // MARK: - Initializer
    init(bannerViewModel: BannerViewModel,
         dDayViewModel: DDayViewModel,
         homeFeedViewModel: HomeFeedViewModel,
         bottomSheetViewModel: BottomSheetViewModel
    ) {
        self.bannerViewController = BannerViewController(viewModel: bannerViewModel)
        self.dDayViewController = DDayViewController(viewModel: dDayViewModel)
        self.homeFeedViewController = HomeFeedViewController(viewModel: homeFeedViewModel)
        self.bottomSheetViewController = BottomSheetViewController(viewModel: bottomSheetViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        // 일정 데이터 먼저 받아오고 조건에 따라 setup
        bottomSheetViewController.viewModel.fetchDailySchedule { [weak self] hasSchedule in
            guard let self = self else { return }
            if hasSchedule {
                self.setupFloatingPanel(contentViewController: self.bottomSheetViewController)
            } else {
                print("오늘 일정 없음! => BottomSheet 띄우지 않음")
            }
        }
//        setupFloatingPanel(contentViewController: bottomSheetViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.addSubview(mainHomeView)
        mainHomeView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Add child view controllers
        addAndLayoutChildViewController(bannerViewController, toView: mainHomeView.bannerView)
        addAndLayoutChildViewController(dDayViewController, toView: mainHomeView.dDayView)
        addAndLayoutChildViewController(homeFeedViewController, toView: mainHomeView.homeFeedView)
    }
    
    private func setupFloatingPanel(contentViewController: UIViewController) {
        fpc = FloatingPanelController()
        fpc.set(contentViewController: contentViewController)
        fpc.layout = BottomSheetPanelLayout()
        fpc.addPanel(toParent: self)
        fpc.surfaceView.maximumContentSizeCategory = .medium
        fpc.changePanelStyle()
        
        fpc.delegate = self
        
        // 백드롭 설정 (기본값은 hidden일 수 있음)
        fpc.backdropView.backgroundColor = .black
        
        if fpc.state == .half {
            fpc.backdropView.alpha = 0.3 // 초기값은 0
            fpc.backdropView.isHidden = false
        } else {
            fpc.backdropView.alpha = 0.0 // 초기값은 0
            fpc.backdropView.isHidden = true
        }
        
        // backdrop 자동 업데이트 비활성화
        fpc.isRemovalInteractionEnabled = false
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backdropTapped))
        fpc.backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backdropTapped() {
        fpc.move(to: .tip, animated: true)
    }
    
    private func setupActions() {
        mainHomeView.titleView.notificationButton.addTarget(self, action: #selector(moveToNotification), for: .touchUpInside)
    }
    
    private func addAndLayoutChildViewController(_ child: UIViewController, toView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    @objc private func moveToNotification() {
        let notificationView = NotificationView()
        let hostingController = UIHostingController(rootView: notificationView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20
        appearance.backgroundColor = .brandHighLight1
        
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = .black
        shadow.offset = CGSize(width: 0, height: 2)
        shadow.opacity = 0.08
        shadow.radius = 2
        appearance.shadows = [shadow]
        
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandle.barColor = .white
        surfaceView.grabberHandleSize = CGSize(width: 133, height: 4)
        surfaceView.grabberHandlePadding = 10
        
        surfaceView.contentPadding = .init(top: 34, left: 0, bottom: 0, right: 0)
        surfaceView.appearance = appearance
    }
}

extension MainHomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        updateBackdropVisibility(for: fpc.state)
    }
    
    private func updateBackdropVisibility(for state: FloatingPanelState) {
        let shouldShowBackdrop = (state == .half || state == .full)
        self.fpc.backdropView.isHidden = false
        self.fpc.backdropView.backgroundColor = .black
        self.fpc.backdropView.alpha = shouldShowBackdrop ? 0.3 : 0.0
        
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        updateBackdropVisibility(for: fpc.state)
    }
}
