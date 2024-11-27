//
//  FeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/11/2024.
//

import Foundation

class FeedViewModel {
    private let getFeedListUseCase: GetFeedListUseCase
    
    private var page: Int32 = 0
    private var isLoading = false
    
    private(set) var feeds: [FeedContent] = [] {
        didSet {
//            self.onFeedsDataFetched?()
//            updateFeedImagesForCurrentIndex()
        }
    }
    
    init(getFeedListUseCase: GetFeedListUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
    }
    
    func fetchFeeds() {
        getFeedListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data):
                self.feeds.append(contentsOf: data)
                self.page += 1
            case .failure(let error):
                print(error)
            }
        }
    }
}
