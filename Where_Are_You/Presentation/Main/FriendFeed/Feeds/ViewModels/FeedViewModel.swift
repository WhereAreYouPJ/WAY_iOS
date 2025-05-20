//
//  FeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/11/2024.
//

import Foundation
import Kingfisher

class FeedViewModel {
    // MARK: - Properties
    private let getFeedListUseCase: GetFeedListUseCase
    private let deleteFeedUseCase: DeleteFeedUseCase
    private let postHideFeedUseCase: PostHideFeedUseCase
    
    private let postBookMarkFeedUseCase: PostBookMarkFeedUseCase
    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    var onFeedsDataFetched: (() -> Void)?
    
    private(set) var currentIndex = 0
    
    var page: Int32 = 0
    private var isLoading = false
    
    private var rawFeedContent: [FeedContent] = []
    var displayFeedContent: [Feed] = [] {
        didSet {
            self.onFeedsDataFetched?()
        }
    }
        
    // MARK: - Initializer
    init(getFeedListUseCase: GetFeedListUseCase,
         deleteFeedUseCase: DeleteFeedUseCase,
         postHideFeedUseCase: PostHideFeedUseCase,
         postBookMarkFeedUseCase: PostBookMarkFeedUseCase,
         deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.postHideFeedUseCase = postHideFeedUseCase
        self.postBookMarkFeedUseCase = postBookMarkFeedUseCase
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
    }
    
    // MARK: - Helpers
    func fetchFeeds() {
        print("DEBUG: 피드 데이터 리스트 불러오는중,,,")

        getFeedListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data):
                self.rawFeedContent = data
                self.page += 1
                self.displayFeedContent.append(contentsOf: data.compactMap { $0.toFeeds() })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFeed(feedSeq: Int) {
        deleteFeedUseCase.execute(request: DeleteFeedRequest(memberSeq: memberSeq, feedSeq: feedSeq)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = self.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                    self.displayFeedContent.remove(at: index)
                }
                self.onFeedsDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func hideFeed(feedSeq: Int) {
        postHideFeedUseCase.execute(feedSeq: feedSeq) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.onFeedsDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func postFeedBookMark(feedSeq: Int) {
        postBookMarkFeedUseCase.execute(request: BookMarkFeedRequest(feedSeq: feedSeq, memberSeq: memberSeq)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self?.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                        self?.displayFeedContent[index].bookMark = true
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFeedBookMark(feedSeq: Int) {
        deleteBookMarkFeedUseCase.execute(request: BookMarkFeedRequest(feedSeq: feedSeq, memberSeq: memberSeq)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self?.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                        self?.displayFeedContent[index].bookMark = false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
