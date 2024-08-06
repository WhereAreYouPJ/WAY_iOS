//
//  MainHomeViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import UIKit

class MainHomeViewController: UIViewController {
    // MARK: - Properties
    
    private var mainHomeView = MainHomeView()
    private var mainHomeViewModel: MainHomeViewModel!
    private var bannerViewController: BannerViewController!
    private var scheduleViewController: ScheduleViewController!
    private var feedTableViewController: HomeFeedViewController!
    
    private let titleView = TitleView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainHomeView
        mainHomeViewModel = MainHomeViewModel()
        setupViewControllers()
        setupBindings()
        buttonActions()
        setupNavigationBar()
        
        mainHomeViewModel.loadData()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView.titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleView.iconStack)
        
        // 화면을 스크롤 했을때 네비게이션바가 여전히 색상을 유지
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.white
        // 네비게이션 분리선 없애기
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setupViewControllers() {
        // 서브뷰 컨트롤러 초기화
        bannerViewController = BannerViewController()
        scheduleViewController = ScheduleViewController()
        feedTableViewController = HomeFeedViewController()
        
        // 서브뷰 컨트롤러를 자식 컨트롤러로 추가
        addChild(bannerViewController)
        addChild(scheduleViewController)
        addChild(feedTableViewController)
        
        // 서브뷰 컨트롤러의 뷰가 부모 컨트롤러에 추가되었음을 알림
        bannerViewController.didMove(toParent: self)
        scheduleViewController.didMove(toParent: self)
        feedTableViewController.didMove(toParent: self)
        
        // 각 서브 뷰 컨트롤러의 뷰를 메인 뷰에 추가
        mainHomeView.addSubview(bannerViewController.view)
        mainHomeView.addSubview(scheduleViewController.view)
        mainHomeView.addSubview(feedTableViewController.view)
        
        // 레이아웃 설정
        bannerViewController.view.snp.makeConstraints { make in
            make.top.equalTo(mainHomeView.bannerView)
            make.leading.trailing.equalTo(mainHomeView.bannerView)
            make.height.equalTo(mainHomeView.bannerView.snp.height)
        }
        
        scheduleViewController.view.snp.makeConstraints { make in
            make.top.equalTo(mainHomeView.scheduleView)
            make.leading.trailing.equalTo(mainHomeView.scheduleView)
            make.height.equalTo(mainHomeView.scheduleView.snp.height)
        }
        
        feedTableViewController.view.snp.makeConstraints { make in
            make.top.equalTo(mainHomeView.homeFeedView)
            make.leading.trailing.equalTo(mainHomeView.homeFeedView)
            make.height.equalTo(mainHomeView.homeFeedView.snp.height)
        }
    }
    
    private func setupBindings() {
        mainHomeViewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let bannerImages = self?.mainHomeViewModel.getBannerImages() else {
                    print("배너 이미지 로드 실패")
                    return
                }
                self?.bannerViewController.viewModel.setBanners(bannerImages)
            }
        }
        
        mainHomeViewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.scheduleViewController.viewModel.setSchedules(self?.mainHomeViewModel.getSchedules() ?? [])
            }
        }
        
        mainHomeViewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedTableViewController.viewModel.setFeeds(self?.mainHomeViewModel.getFeeds() ?? [])
            }
        }
    }
    
    private func buttonActions() {
        titleView.notificationButton.addTarget(self, action: #selector(moveToNotification), for: .touchUpInside)
        titleView.profileButton.addTarget(self, action: #selector(moveToMyPage), for: .touchUpInside)
    }
    
    @objc private func moveToNotification() {
        // 알림 페이지로 이동
    }
    
    @objc private func moveToMyPage() {
        // 마이 페이지 이동
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 3
        }
    }
}
