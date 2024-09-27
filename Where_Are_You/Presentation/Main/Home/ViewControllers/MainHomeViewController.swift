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
    private var dDayViewController: DDayViewController!
    private var homeFeedViewController: HomeFeedViewController!
    
    private let titleView = TitleView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainHomeView)
        mainHomeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        setupViewModel()
        setupNavigationBar()
        setupViewControllers()
        setupBindings()
        buttonActions()
        
        mainHomeViewModel.loadData()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let scheduleService = ScheduleService()
        let scheduleRepository = ScheduleRepository(scheduleService: scheduleService)
        mainHomeViewModel = MainHomeViewModel(
            getDDayScheduleUseCase: GetDDayScheduleUseCaseImpl(scheduleRepository: scheduleRepository)
        )
    }
    
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
        bannerViewController = BannerViewController()
        dDayViewController = DDayViewController()
        homeFeedViewController = HomeFeedViewController()
        
        addAndLayoutChildViewController(bannerViewController, toView: mainHomeView.bannerView)
        addAndLayoutChildViewController(dDayViewController, toView: mainHomeView.dDayView)
        addAndLayoutChildViewController(homeFeedViewController, toView: mainHomeView.homeFeedView)
    }
    
    private func setupBindings() {
        mainHomeViewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let bannerImages = self?.mainHomeViewModel.getBannerImages() else { return }
                self?.bannerViewController.viewModel.setBanners(bannerImages)
            }
        }
        
        mainHomeViewModel.onDDayDataFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let dDays = self?.mainHomeViewModel.getDDays() else { return }
                self?.dDayViewController.viewModel.setDDays(dDays)
            }
        }
        
        mainHomeViewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let homeFeed = self?.mainHomeViewModel.getFeeds() else { return }
                self?.homeFeedViewController.viewModel.setFeeds(homeFeed)
            }
        }
    }
    
    private func buttonActions() {
        titleView.notificationButton.addTarget(self, action: #selector(moveToNotification), for: .touchUpInside)
        titleView.profileButton.addTarget(self, action: #selector(moveToMyPage), for: .touchUpInside)
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
        // 알림 페이지로 이동
    }
    
    @objc private func moveToMyPage() {
        // 마이 페이지 이동
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 3
        }
    }
}
