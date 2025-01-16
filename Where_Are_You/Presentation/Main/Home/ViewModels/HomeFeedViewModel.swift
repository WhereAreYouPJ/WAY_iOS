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
    private var displayFeedContent: [Feed] = []
    
    init(getFeedListUseCase: GetFeedListUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
    }
    
    // MARK: - Helpers
    
    // 피드를 불러오는 메서드
    func fetchFeeds(completion: @escaping ([Feed]) -> Void) {
        getFeedListUseCase.execute(page: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.rawFeedContent = data
                self.displayFeedContent = rawFeedContent.compactMap { $0.toFeeds() }
                DispatchQueue.main.async {
                    self.onFeedsDataFetched?()
                    completion(self.displayFeedContent)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFeeds() -> [Feed] {
        return displayFeedContent
    }
    
    func shouldShowMoreFeedsCell() -> Bool {
        return displayFeedContent.count > 9
    }
}
