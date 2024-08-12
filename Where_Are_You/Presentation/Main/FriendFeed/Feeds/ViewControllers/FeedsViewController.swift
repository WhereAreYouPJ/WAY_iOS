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
    private let feedsView = FeedsView()
    var viewModel: FeedDetailViewModel!
    
    // MARK: - Lifecycle
    override func loadView() {
        view = feedsView
        viewModel = FeedDetailViewModel()
        setupBindings()
        setupTableView()
    }
    
    // MARK: - Helpers
    private func setupBindings() {
//        viewModel.onFeedImageDataFetched = { [weak self] in
////            self?.feedsView.feeds = self?.viewModel.getFeeds() ?? []
//            self?.feedsView.feedsTableView.reloadData()
//        }
    }
    
    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.feeds[indexPath.row]
        if feed.feedImages == nil {
            cell.feedImageView.isHidden = true
        } else if feed.description == nil {
            cell.descriptionLabel.isHidden = true
        }
        cell.detailBox.titleLabel.text = feed.title
        cell.detailBox.dateLabel.text = feed.date?.description
        cell.detailBox.locationLabel.text = feed.location
        cell.detailBox.profileImage.image = feed.profileImage
        
        return cell
    }
}

//struct PreView: PreviewProvider {
//    static var previews: some View {
//        FeedsViewController().toPreview()
//    }
//}
//
//#if DEBUG
//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//            let viewController: UIViewController
//
//            func makeUIViewController(context: Context) -> UIViewController {
//                return viewController
//            }
//
//            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//            }
//        }
//
//        func toPreview() -> some View {
//            Preview(viewController: self)
//        }
//}
//#endif
