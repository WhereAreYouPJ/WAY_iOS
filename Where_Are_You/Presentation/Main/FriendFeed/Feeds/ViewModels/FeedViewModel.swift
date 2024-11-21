//
//  FeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/11/2024.
//

import Foundation

class FeedViewModel {
    // MARK: - Properties
    private let getFeedListUseCase: GetFeedListUseCase
    
    var onFeedsDataFetched: (() -> Void)?
    
    private var page: Int32 = 0
    private var isLoading = false
    private var rawFeedContent: [FeedContent] = []
    private(set) var displayFeedContent: [MainFeedListContent] = [] {
        didSet {
            self.onFeedsDataFetched?()
            updateFeedImagesForCurrentIndex()
        }
    }
    
    // MARK: - Initializer
    init(getFeedListUseCase: GetFeedListUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
    }
    
    // MARK: - Helpers
    func fetchFeeds() {
        getFeedListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let data):
                self.rawFeedContent = data
                self.displayFeedContent = rawFeedContent.compactMap { feedContent in
                    guard let scheduleFeedInfo = feedContent.scheduleFeedInfo.first else { return nil }
        
                    return MainFeedListContent(
                        profileImage: scheduleFeedInfo.memberInfo.profileImage,
                        startTime: feedContent.scheduleInfo.startTime,
                        location: feedContent.scheduleInfo.location,
                        title: scheduleFeedInfo.feedInfo.title,
                        content: scheduleFeedInfo.feedInfo.content,
                        scheduleFriendInfos: feedContent.scheduleFriendInfo,
                        feedImageInfos: scheduleFeedInfo.feedImageInfos
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
    
    private func updateFeedImagesForCurrentIndex() {
        
    }
}
