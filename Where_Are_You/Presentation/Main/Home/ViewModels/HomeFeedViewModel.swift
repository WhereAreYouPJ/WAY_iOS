//
//  HomeFeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation
import UIKit

class HomeFeedViewModel {
    // MARK: - Properties
    
    private let getFeedListUseCase: GetFeedListUseCase
    
    var onFeedsDataFetched: (() -> Void)?
    private var rawFeedContent: [FeedContent] = []
    private var displayFeedContent: [HomeFeedContent] = []
    
    init(getFeedListUseCase: GetFeedListUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
    }
    
    // MARK: - Helpers
    
    // 피드를 불러오는 메서드
    func fetchFeeds() {
        getFeedListUseCase.execute(page: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.rawFeedContent = data
                self.displayFeedContent = rawFeedContent.compactMap { feedContent in
                    guard let scheduleFeedInfo = feedContent.scheduleFeedInfo.first else { return nil }
                    
                    return HomeFeedContent(
                        profileImageURL: scheduleFeedInfo.memberInfo.profileImageURL,
                        location: feedContent.scheduleInfo.location,
                        title: scheduleFeedInfo.feedInfo.title,
                        content: scheduleFeedInfo.feedInfo.content,
                        feedImage: scheduleFeedInfo.feedImageInfos.first?.feedImageURL
                    )
                }
                DispatchQueue.main.async {
                    self.onFeedsDataFetched?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFeeds() -> [HomeFeedContent] {
        return displayFeedContent
    }
    
    func shouldShowMoreFeedsCell() -> Bool {
        return displayFeedContent.count > 9
    }
}
