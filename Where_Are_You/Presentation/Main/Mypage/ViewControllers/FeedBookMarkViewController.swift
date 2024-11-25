//
//  FeedBookMarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import UIKit

class FeedBookMarkViewController: UIViewController {
    // MARK: - Properties
    private let feedBookMarkView = FeedBookMarkView()
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.descriptionLabel.text = "아직은 피드에 책갈피를 하지 않았어요. \n특별한 추억을 오래도록 기억할 수 있게 \n피드를 책갈피 해보세요!"
        return view
    }()
    
    var viewModel: FeedBookMarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupTableView()
        setupViewModel()
        setupBindings()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "피드 책갈피", backButtonAction: #selector(backButtonTapped), showBackButton: true)
    }
    
    private func setupTableView() {
        feedBookMarkView.feedsBookMarkTableView.delegate = self
        feedBookMarkView.feedsBookMarkTableView.dataSource = self
        feedBookMarkView.feedsBookMarkTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedBookMarkViewModel(
            getBookMarkFeedUseCase: GetBookMarkFeedUseCaseImpl(feedRepository: feedRepository),
            deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onBookMarkFeedUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.feedBookMarkView.feedsBookMarkTableView.reloadData()
            }
        }
    }
    
    private func setupActions() {
        
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension FeedBookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

extension FeedBookMarkViewController: FeedBookMarkViewModelDelegate {
    func didUpdateBookMarkFeed() {
        feedBookMarkView.feedsBookMarkTableView.reloadData()
    }
}
