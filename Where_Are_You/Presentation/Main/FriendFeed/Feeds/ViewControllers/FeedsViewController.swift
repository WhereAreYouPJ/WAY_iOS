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
    let plusOptionButton = CustomOptionButtonView(title: "새 피드 작성")

    var viewModel: FeedViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupTableView()
        setupBindings()
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
                self?.feedsView.feedsTableView.reloadData()
                self?.feedsView.updateContentHeight()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedsView)
        feedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        plusOptionButton.isHidden = true
        
        view.addSubview(plusOptionButton)

        plusOptionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
            make.width.equalTo(160)
            make.height.equalTo(38)
        }
    }
    
    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.rowHeight = UITableView.automaticDimension
        feedsView.feedsTableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 416)
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func setupActions() {
        plusOptionButton.button.addTarget(self, action: #selector(plusOptionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Selectors

    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !plusOptionButton.frame.contains(location) {
            plusOptionButton.isHidden = true
        }
    }
    
    @objc func plusOptionButtonTapped() {
        plusOptionButton.isHidden = true
        let controller = AddFeedViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(viewModel.displayFeedContent.count)")
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
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 44))
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
            return LayoutAdapter.shared.scale(value: 600)
        }
        return UITableView.automaticDimension
    }
}
