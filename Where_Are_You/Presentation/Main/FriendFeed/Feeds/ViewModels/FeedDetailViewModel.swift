//
//  FeedDetailViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/8/2024.
//

import UIKit

class FeedDetailViewModel {
    private let getFeedDetailsUseCase: GetFeedDetailsUseCase
    
    var onFeedsDataFetched: (() -> Void)?
    var onFeedImagesUpdated: (([UIImage]) -> Void)?
    var onCurrentImageIndexChanged: ((Int) -> Void)?
    
    private var page: Int32 = 0
    private var isLoading = false
    
    private var rawFeedContent: FeedContent?
    private(set) var displayFeedContent: [Feed] = [] {
        didSet {
            self.onFeedsDataFetched?()
        }
    }
    
    // MARK: - Lifecycle
    init(getFeedDetailsUseCase: GetFeedDetailsUseCase) {
        self.getFeedDetailsUseCase = getFeedDetailsUseCase
    }
    
    // MARK: - Helpers
    
    // 서버에서 피드 데이터를 가져오는 메서드
    func fetchDetailFeeds(scheduleSeq: Int, participantsMemberSeq: [Int]) {
        for memberSeq in participantsMemberSeq {
            getFeedDetailsUseCase.execute(scheduleSeq: scheduleSeq, memberSeq: memberSeq) { result in
                switch result {
                case .success(let data):
                    self.rawFeedContent = data
                    self.displayFeedContent.append(data.toFeeds())
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getParticipantFeed(index: Int) -> Feed {
        return displayFeedContent[index]
    }
}
