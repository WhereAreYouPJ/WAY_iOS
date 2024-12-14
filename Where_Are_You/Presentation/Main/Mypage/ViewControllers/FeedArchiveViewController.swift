//
//  FeedArchiveViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/12/2024.
//

import UIKit

class FeedArchiveViewController: UIViewController {
    private let feedBookMarkView = FeedBookMarkView()

    var viewModel: FeedArchiveViewModel!
        
}

extension FeedArchiveViewController: FeedsTableViewCellDelegate {
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        viewModel.deleteBookMarkFeed(feedSeq: feedSeq)
        // 북마크 상태 변경 후 해당 셀만 업데이트
        if let index = viewModel.displayBookMarkFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
            let indexPath = IndexPath(row: index, section: 0)
            feedBookMarkView.feedsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
//        let isAuthor = feed.memberSeq == UserDefaultsManager.shared.getMemberSeq()
//        guard let feedSeq = feed.feedSeq else { return }
//        showFeedOptions(
//            feed: feed,
//            isAuthor: isAuthor,
//            currentViewType: .archive,
//            deleteAction: { self.viewModel.deleteBookMarkFeed(feedSeq: feedSeq) },
//            editAction: {},
//            hideAction: {},
//            restoreAction: { self.viewModel.restoreFeed(feedSeq: feedSeq) }
//        )
    }
}
