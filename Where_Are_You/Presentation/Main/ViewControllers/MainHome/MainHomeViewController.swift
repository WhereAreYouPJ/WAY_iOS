//
//  MainHomeViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import UIKit

class MainHomeViewController: UIViewController {
    // MARK: - Properties
    
    private var mainHomeView: MainHomeView!
    private var bannerViewController: BannerViewController!
    private var scheduleViewController: ScheduleViewController!
    private var feedTableViewController: FeedTableViewController!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        mainHomeView = MainHomeView(frame: UIScreen.main.bounds)
        view = mainHomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTableView()
        setupBindings()
        
        // 각각의 뷰모델이 데이터를 가져오도록 설정
        bannerViewController.viewModel.fetchBannerImages()
        scheduleViewController.viewModel.fetchSchedules()
        feedTableViewController.viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers
    
    private func setupViewControllers() {
        // 서브뷰 컨트롤러 초기화
        bannerViewController = BannerViewController()
        scheduleViewController = ScheduleViewController()
        feedTableViewController = FeedTableViewController()
        
        // 서브뷰 컨트롤러의 뷰 모델 초기화 확인
        feedTableViewController.viewModel = FeedTableViewModel() // viewModel 초기화
        
        // 서브뷰 컨트롤러를 자식 컨트롤러로 추가
        addChild(bannerViewController)
        addChild(scheduleViewController)
        addChild(feedTableViewController)
        
        // 서브뷰 컨트롤러의 뷰가 부모 컨트롤러에 추가되었음을 알림
        bannerViewController.didMove(toParent: self)
        scheduleViewController.didMove(toParent: self)
        feedTableViewController.didMove(toParent: self)
        
        // HeaderView에 배너뷰와 스케쥴뷰 추가
        mainHomeView.headerView.bannerView.addSubview(bannerViewController.view)
        mainHomeView.headerView.scheduleView.addSubview(scheduleViewController.view)
        
        bannerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scheduleViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        mainHomeView.tableView.delegate = self
        mainHomeView.tableView.dataSource = self
    }
    
    private func setupBindings() {
        bannerViewController.viewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        
        scheduleViewController.viewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        
        feedTableViewController.viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MainHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 메인 섹션, 피드 섹션
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 메인 섹션
        case 1:
            return feedTableViewController.viewModel.getFeeds().count // 피드 섹션
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.contentView.addSubview(mainHomeView.headerView)
            
            mainHomeView.headerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            return cell
        case 1:
            return feedTableViewController.tableView(tableView, cellForRowAt: indexPath) // 피드 섹션
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let headerView = UIView()
            headerView.addSubview(feedTableViewController.feedTableView.reminderButton)
            feedTableViewController.feedTableView.reminderButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            }
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

// MARK: - UITableViewDelegate

extension MainHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension // 메인 섹션 높이 자동 조절
        case 1:
            return UITableView.automaticDimension // 피드 높이 자동 조절
        default:
            return 0
        }
    }
}
