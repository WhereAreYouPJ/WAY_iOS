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
    private let titleView = TitleView()
    
    private let bannerViewController: BannerViewController
    private let dDayViewController: DDayViewController
    private let homeFeedViewController: HomeFeedViewController
    
    // MARK: - Initializer
    init(bannerViewModel: BannerViewModel,
         dDayViewModel: DDayViewModel,
         homeFeedViewModel: HomeFeedViewModel
    ) {
        self.bannerViewController = BannerViewController(viewModel: bannerViewModel)
        self.dDayViewController = DDayViewController(viewModel: dDayViewModel)
        self.homeFeedViewController = HomeFeedViewController(viewModel: homeFeedViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.addSubview(mainHomeView)
        mainHomeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Add child view controllers
        addAndLayoutChildViewController(bannerViewController, toView: mainHomeView.bannerView)
        addAndLayoutChildViewController(dDayViewController, toView: mainHomeView.dDayView)
        addAndLayoutChildViewController(homeFeedViewController, toView: mainHomeView.homeFeedView)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView.titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleView.iconStack)
        
        // 화면을 스크롤 했을때 네비게이션바가 여전히 색상을 유지
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.white
        navigationBarAppearance.shadowColor = .clear // 네비게이션 분리선 없애기
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
//    private func setupBindings() {
//        bannerViewController.viewModel.onBannerDataFetched = { [weak self] in
//            DispatchQueue.main.async {
//                self?.bannerViewController.updateUI()
//            }
//        }
//        
//        dDayViewController.viewModel.onDDayDataFetched = { [weak self] in
//            DispatchQueue.main.async {
//                self?.dDayViewController.updateUI()
//            }
//        }
//        
//        homeFeedViewController.viewModel.onFeedsDataFetched = { [weak self] in
//            DispatchQueue.main.async {
//                self?.homeFeedViewController.updateUI()
//            }
//        }
//    }
    
    private func setupActions() {
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
    //    private func setupBindings() {
    //        mainHomeViewModel.onBannerDataFetched = { [weak self] in
    //            DispatchQueue.main.async {
    //                guard let bannerImages = self?.mainHomeViewModel.getBannerImages() else { return }
    //                self?.bannerViewController.viewModel.setBanners(bannerImages)
    //            }
    //        }
    //
    //        mainHomeViewModel.onDDayDataFetched = { [weak self] in
    //            DispatchQueue.main.async {
    //                guard let dDays = self?.mainHomeViewModel.getDDays() else { return }
    //                self?.dDayViewController.viewModel.setDDays(dDays)
    //            }
    //        }
    //
    //        mainHomeViewModel.onFeedsDataFetched = { [weak self] in
    //            DispatchQueue.main.async {
    //                guard let homeFeed = self?.mainHomeViewModel.getFeeds() else { return }
    //                self?.homeFeedViewController.viewModel.setFeeds(homeFeed)
    //            }
    //        }
    //    }
    // MARK: - Selectors
    @objc private func moveToNotification() {
        // 알림 페이지로 이동
    }
    
    @objc private func moveToMyPage() {
        tabBarController?.selectedIndex = 3
    }
}
