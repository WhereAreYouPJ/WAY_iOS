//
//  FeedTableViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class FeedTableViewController: UIViewController {
    let feedTableView = FeedTableView()
    var viewModel: FeedTableViewModel!
    
    override func loadView() {
        view = feedTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedTableViewModel()
        setupBindings()
        setupTableView()
        viewModel.fetchFeeds()
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedTableView.feeds = self?.viewModel.getFeeds() ?? []
            }
        }
    }
    
    private func setupTableView() {
        feedTableView.tableView.dataSource = self
        feedTableView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFeeds().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            fatalError("Unable to dequeue FeedTableViewCell")
        }
        let feed = viewModel.getFeeds()[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
    
    // 해당 셀을 눌렀을때 피드 페이지로 넘어가게 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let feed = viewModel.getFeeds()[indexPath.row]
        //        let detailViewController = FeedDetailViewController()
        //        detailViewController.configure(with: feed)
        //        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
