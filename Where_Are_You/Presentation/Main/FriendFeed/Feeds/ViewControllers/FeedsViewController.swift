//
//  FeedsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SwiftUI

class FeedsViewController: UIViewController {
    // MARK: - Properties
    private var feedsView = FeedsView()
    private var noFeedsView = NoDataView()
    var viewModel: FeedViewModel!
//    private var feedImagesViewController: FeedImagesViewController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FeedsViewController - viewDidLoad() called") // 확인 로그
        print("Is viewModel nil? \(viewModel == nil)") // viewModel nil 여부 확인
        
        setupViewModel()
        print("Is viewModel nil after setupViewModel? \(viewModel == nil)") // viewModel 초기화 여부 확인
        
        setupViews()
        setupTableView()
        setupBindings()
//        addFeedImagesViewController()
        viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedViewModel(getFeedListUseCase: GetFeedListUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedsView.updateContentHeight()
                self?.feedsView.feedsTableView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedsView)
        feedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }

    private func addFeedImagesViewController() {
//        feedImagesViewController = FeedImagesViewController()
//        addChild(feedImagesViewController)
//        feedsView.addSubview(feedImagesViewController.view)
//        feedImagesViewController.didMove(toParent: self)
//        
//        feedImagesViewController.view.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayFeedContent.isEmpty ? 1 : viewModel.displayFeedContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.displayFeedContent.isEmpty {
            // NoDataView를 포함한 UITableViewCell 생성
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDataCell")
            cell.selectionStyle = .none
            // NoDataView를 셀의 컨텐츠로 추가
            cell.contentView.addSubview(noFeedsView)
            // NoDataView의 레이아웃 설정
            noFeedsView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 7))
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 125))
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.displayFeedContent[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.displayFeedContent.isEmpty {
            return tableView.frame.height
        }
        return UITableView.automaticDimension
    }
}
