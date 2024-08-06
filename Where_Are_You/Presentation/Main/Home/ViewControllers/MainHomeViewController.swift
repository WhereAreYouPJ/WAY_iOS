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
    private var bannerViewController: BannerViewController!
    private var scheduleViewController: ScheduleViewController!
    private var feedTableViewController: HomeFeedViewController!
    
    private let titleView = TitleView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainHomeView
        
        setupViewControllers()
        setupBindings()
        buttonActions()
        setupNavigationBar()
        
        // 각각의 뷰모델이 데이터를 가져오도록 설정
        bannerViewController.viewModel.fetchBannerImages()
        scheduleViewController.viewModel.fetchSchedules()
        feedTableViewController.viewModel.fetchFeeds()
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
        
        // 서브뷰 컨트롤러의 뷰 모델 초기화 확인
        feedTableViewController.viewModel = FeedViewModel() // viewModel 초기화
        
        // 서브뷰 컨트롤러를 자식 컨트롤러로 추가
        addChild(bannerViewController)
        addChild(scheduleViewController)
        addChild(feedTableViewController)
        
        // 서브뷰 컨트롤러의 뷰가 부모 컨트롤러에 추가되었음을 알림
        bannerViewController.didMove(toParent: self)
        scheduleViewController.didMove(toParent: self)
        feedTableViewController.didMove(toParent: self)
        
        bannerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scheduleViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        bannerViewController.viewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
//                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        
        scheduleViewController.viewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
//                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        
        feedTableViewController.viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
//                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
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
